import express from 'express';
// controllers
import user from '../controllers/user.js';

const router = express.Router();

router
  .post('/names', user.onGetMultipleUsers)
  .post('/', user.onCreateUser)
  .get('/:id', user.onGetUserById)
  .delete('/:id', user.onDeleteUserById)

export default router;