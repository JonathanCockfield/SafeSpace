import express from 'express';
//controller
import match from '../controllers/match.js';

const router = express.Router();

router
  .post('/', match.makeNewMatch)
  .delete('/', match.deleteMatch);

export default router;