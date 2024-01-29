// utils
import makeValidation from '@withvoid/make-validation';
// models
import UserModel, { USER_TYPES } from '../models/User.js';
import MatchListModel from '../models/MatchList.js';

export default {
    makeNewMatch: async (req, res) => {
        try {
            const validation = makeValidation(types => ({
              payload: req.body,
              checks: {
                illness: { 
                  type: types.array, 
                  options: { unique: true, empty: false, stringOnly: true } 
                }
              }
            }));
            if (!validation.success) return res.status(400).json({ ...validation });
        
            const { illness } = req.body;
            const userId = req.userId;

            // find a new match, if none were found return error
            const newMatch = await MatchListModel.getNewMatch(illness);
            if (!newMatch) {
              return res.status(500).json({ success: false, error: 'Could not find a match.'}); 
            }

            // update matches
            await UserModel.newMatch(userId, newMatch._id);
            await UserModel.newMatch(newMatch._id, userId);

            return res.status(200).json({ success: true, newMatch });
        } catch (error) {
            return res.status(500).json({ success: false, error: error });
        }
    },

    deleteMatch: async (req, res) => {
      try {
        const validation = makeValidation(types => ({
          payload: req.body,
          checks: {
            matchId: { type: types.string }
          }
        }));
        if (!validation.success) return res.status(400).json({ ...validation });
        
        const matchId = req.body.matchId;
        const userId = req.userId;

        const result = await UserModel.deleteMatch(userId, matchId);
        await UserModel.deleteMatch(matchId, userId);
  
        return res.status(200).json({ success: true, result });
      } catch (error) {
        return res.status(500).json({ success: false, error: error });
      }
    }
}