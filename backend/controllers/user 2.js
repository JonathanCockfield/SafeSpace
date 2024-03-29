// utils
import makeValidation from '@withvoid/make-validation';
// models
import UserModel, { USER_TYPES } from '../models/User.js';

export default {
    // function will return all users
    onGetAllUsers: async (req, res) => {
        try {
            const users = await UserModel.getUsers();
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
                _id: { type: types.string },
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
            
            // now actually add the user to the database
            const { id, firstName, lastName, age, illness, biography, type } = req.body;
            const user = await UserModel.createUser(id, firstName, age, illness, biography, lastName, type);
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