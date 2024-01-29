// utils
import makeValidation from '@withvoid/make-validation';
// models
import UserModel, { USER_TYPES } from '../models/User.js';
import MatchList from '../models/MatchList.js';

export default {
    // function will return all users
    onGetMultipleUsers: async (req, res) => {
        try {
            const validation = makeValidation(types => ({
                payload: req.body,
                checks: {
                  userIds: { 
                      type: types.array,
                      options: { unique: true, empty: false, stringOnly: true }
                  }
                }
              }));
              if (!validation.success) return res.status(400).json(validation);

            const userIds = req.body.userIds;

            const users = await UserModel.getMultipleUsers(userIds);
            return res.status(200).json({ success: true, users });
        } catch (error) {
            return res.status(500).json({ success: false, error: error })
        }
    },

    // function will retrieve a user by their UUID
    onGetUserById: async (req, res) => {
        try {
            const user = await UserModel.getUserById(req.params.id);
            return res.status(200).json({ success: true, user });
        } catch (error) {
            return res.status(500).json({ success: false, error: error })
        }
    },

    // function will validate and create a new user given creds
    onCreateUser: async (req, res) => {
        try {
            // first make sure all fields are valid.
            const validation = makeValidation(types => ({
              payload: req.body,
              checks: {
                firstName: { type: types.string },
                lastName: { type: types.string },
                age: { type: types.string },
                illness: { 
                    type: types.array,
                    options: { unique: true, empty: false, stringOnly: true }
                },
                biography: { type: types.string },
                type: { type: types.enum, options: { enum: USER_TYPES } },
              }
            }));
            if (!validation.success) return res.status(400).json(validation);

            const _id = req.userId;
            
            // now actually add the user to the database
            const { firstName, lastName, age, illness, biography, type } = req.body;
            const user = await UserModel.createUser(_id, firstName, lastName, age, illness, biography, type);

            // add the user to matchmaking list if mentor
            if (type === USER_TYPES.MENTOR) {
                await MatchList.addToList(_id, illness);
            }

            return res.status(200).json({ success: true, user });
          } catch (error) {
            return res.status(500).json({ success: false, error: error })
          }
    },

    // function to delete a user given UUID
    onDeleteUserById: async (req, res) => { 
        try {
            const user = await UserModel.deleteByUserById(req.params.id);
            return res.status(200).json({ 
              success: true, 
              message: `Deleted a count of ${user.deletedCount} user.` 
            });
        } catch (error) {
            return res.status(500).json({ success: false, error: error })
        }
    },
}