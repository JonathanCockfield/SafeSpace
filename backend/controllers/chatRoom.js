// utils
import makeValidation from '@withvoid/make-validation';
// models
import ChatRoomModel, { CHAT_ROOM_TYPES } from '../models/ChatRoom.js';
import ChatMessageModel from '../models/ChatMessage.js';
import UserModel from '../models/User.js';

import abuse_detection from '../controllers/abuse_detection.js';

import firebaseAdmin from '../config/firebase.js';


function flag(uid, pred)
{

  console.log();
  if( pred.includes('severe_toxicity') ||  pred.includes('identity_attack') || pred.includes('threat') )
  {
    // ban user

    firebaseAdmin.banUser(uid);

    return "banned";
  }
  else
  {
    // flag user
    return "flagged";
  }
}

export default {
    // function creates a new chat room
    initiate: async (req, res) => { 
        try {
            const validation = makeValidation(types => ({
              payload: req.body,
              checks: {
                userIds: { 
                  type: types.array, 
                  options: { unique: true, empty: false, stringOnly: true } 
                },
                type: { type: types.enum, options: { enum: CHAT_ROOM_TYPES } },
              }
            }));
            if (!validation.success) return res.status(400).json({ ...validation });
        
            const { userIds, type } = req.body;
            const { userId: chatInitiator } = req;
            const allUserIds = [...userIds, chatInitiator];
            const chatRoom = await ChatRoomModel.initiateChat(allUserIds, type, chatInitiator);

            // get the new chatroom Id
            const chatRoomId = chatRoom.chatRoomId;
            const chatTarget = req.body.userIds[0];

            // add chatrooms to user profiles page
            await UserModel.newChatroom(chatInitiator, chatRoomId);
            await UserModel.newChatroom(chatTarget, chatRoomId);

            return res.status(200).json({ success: true, chatRoom });
        } catch (error) {
            return res.status(500).json({ success: false, error: error })
        }
    },
    
    postMessage: async (req, res) => { 
      try {
        const { roomId } = req.params;
        const validation = makeValidation(types => ({
          payload: req.body,
          checks: {
            messageText: { type: types.string },
          }
        }));
        if (!validation.success) return res.status(400).json({ ...validation });

        // check if message is abusive
        const prediction = await abuse_detection.predict(req.body.messageText);

        if(prediction.length > 0)
        {
          var err = flag(req.userId, prediction);
          return res.status(200).json({ success: false, error: err });
        }
        else
        {
          const messagePayload = {
            messageText: req.body.messageText,
          };
  
          const currentLoggedUser = req.userId;
          const post = await ChatMessageModel.createPostInChatRoom(roomId, messagePayload, currentLoggedUser);
          global.io.sockets.in(roomId).emit('new message', { message: post });
          return res.status(200).json({ success: true, post });
        }
        
      } catch (error) {
        return res.status(500).json({ success: false, error: error })
      }
    },

    getRecentConversation: async (req, res) => { },

    // function will return conversations from a chat room
    getConversationByRoomId: async (req, res) => {
      try {
        const { roomId } = req.params;
        const room = await ChatRoomModel.getChatRoomByRoomId(roomId)
        if (!room) {
          return res.status(400).json({
            success: false,
            message: 'No room exists for this id',
          })
        }
        const users = await UserModel.getUserByIds(room.userIds);
        const options = {
          page: parseInt(req.query.page) || 0,
          limit: parseInt(req.query.limit) || 10,
        };
        const conversation = await ChatMessageModel.getConversationByRoomId(roomId, options);
        return res.status(200).json({
          success: true,
          conversation,
          users,
        });
      } catch (error) {
        return res.status(500).json({ success: false, error });
      }
    },

    // this call will mark a conversation as read
    markConversationReadByRoomId: async (req, res) => {
      try {
        const { roomId } = req.params;
        const room = await ChatRoomModel.getChatRoomByRoomId(roomId)
        if (!room) {
          return res.status(400).json({
            success: false,
            message: 'No room exists for this id',
          })
        }
    
        const currentLoggedUser = req.userId;
        const result = await ChatMessageModel.markMessageRead(roomId, currentLoggedUser);
        return res.status(200).json({ success: true, data: result });
      } catch (error) {
        return res.status(500).json({ success: false, error });
      }
    },

    // delete a chatroom by its ID
    deleteRoomById: async (req, res) => {
      try {
        const { roomId } = req.params;
        const validation = makeValidation(types => ({
          payload: req.body,
          checks: {
            matchId: { type: types.string }
          }
        }));
        if (!validation.success) return res.status(400).json({ ...validation });

        const userId = req.userId;
        const matchId = req.body.matchId;

        const result = await ChatRoomModel.removeChatroomById(roomId);
        await UserModel.removeChatroom(userId, roomId);
        await UserModel.removeChatroom(matchId, roomId);

        // remove all messages from messages table
        await ChatMessageModel.deleteMessagesByRoom(roomId);

        return res.status(200).json({ success: true, data: result });
      } catch (error) {
        return res.status(500).json({ success: false, error });
      }
    }
}