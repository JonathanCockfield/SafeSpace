// firebase
import admin from 'firebase-admin';
// import serviceAccount from './safespace-165f8-firebase-adminsdk-oazuc-cb7de7b6cc.json';

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  databaseURL: "https://safespace-165f8-default-rtdb.firebaseio.com"
});

console.log("Firebase has connected successfully");

const getAuthToken = (req, res, next) => {
  if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
      req.authToken = req.headers.authorization.split(' ')[1];
  } else {
      req.authToken = null;
  }
  next();
};

export default {
  checkIfAuthenticated: (req, res, next) => {
    getAuthToken(req, res, async () => {
      try {
        const { authToken } = req;
        const userInfo = await admin.auth().verifyIdToken(authToken);
        req.userId = userInfo.uid;
        req.displayName = userInfo.name;
        return next();
      } catch (e) {
        return res.status(401).send({ error: 'You are not authorized to make this request' });
      }
    });
  },

  checkIfAdmin: (req, res, next) => {
    getAuthToken(req, res, async () => {
      try {
        const userInfo = await admin.auth().verifyIdToken(req.authToken);
        if (userInfo.admin === true) {
          req.userId = userInfo.uid;
          req.displayName = userInfo.name;
          return next();
        }
        else {
          return res.status(401).send({ error: 'You are not authorized to make this request' });  
        }
      } catch (e) {
        return res.status(401).send({ error: 'You are not authorized to make this request' });
      }
    });
  },

  banUser: (uid) =>
  {
    admin.auth().updateUser(uid, {
      disabled: true
    });
  }
}