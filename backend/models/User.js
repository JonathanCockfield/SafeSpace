import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";

export const USER_TYPES = {
  MENTOR: "mentor",
  MENTEE: "mentee",
};

// defining what the user table looks like
const userSchema = new mongoose.Schema(
  {
    _id: {
      type: String,
      default: () => uuidv4().replace(/\-/g, ""),
    },
    firstName: String,
    lastName: String,
    age: String,
    illness: [String],
    biography: String,
    chatrooms: {
      type: [String],
      default: () => [null],
    },
    matches: {
      type: [String],
      default: () => [null],
    },
    type: String 
  },
  {
    timestamps: true,
    collection: "users",
  }
);

// function will return all userids and their names from the userIds array
userSchema.statics.getMultipleUsers = async function (userIds) {
  try {
    const users = await this.find(
      { '_id': { $in: userIds} },
      { firstName: 1 }
    );

    return users;
  } catch (error) {
    throw error;
  }
}

// function to retrive a user given UUID as type
userSchema.statics.getUserById = async function (id) {
  try {
    const user = await this.findOne({ _id: id });
    if (!user) throw ({ error: 'No user with this id found' });
    return user;
  } catch (error) {
    throw error;
  }
}

// get multiple users by UUIDs
userSchema.statics.getUserByIds = async function (ids) {
  try {
    const users = await this.find({ _id: { $in: ids } });
    return users;
  } catch (error) {
    throw error;
  }
}

// function to return a new user type
userSchema.statics.createUser = async function (
  _id,
	firstName, 
  lastName,
  age,
  illness,
  biography,
  type
) {
  try {
    const user = await this.create({ _id, firstName, lastName, age, illness, biography, type });
    return user;
  } catch (error) {
    throw error;
  }
}

// function to delete a user given UUID as type
userSchema.statics.deleteByUserById = async function (id) {
  try {
    const result = await this.remove({ _id: id });
    return result;
  } catch (error) {
    throw error;
  }
}

// function to update users matches
userSchema.statics.newMatch = async function (userId, matchId) {
  try {
    const result = await this.findByIdAndUpdate(userId,
      {$push: {"matches": matchId}},
      {safe: true, upsert: true, new: true}
    );

    return result;
  } catch (error) {
    throw error;
  }
}

// function to update chatrooms
userSchema.statics.newChatroom = async function (userId, chatroomId) {
  try {
    const result = await this.findByIdAndUpdate(userId,
      {$push: {"chatrooms": chatroomId}},
      {safe: true, upsert: true, new: true}
    );

    return result;
  } catch (error) {
    throw error;
  }
}

// function to remove a match
userSchema.statics.deleteMatch = async function (userId, matchId) {
  try {
    const result = await this.findByIdAndUpdate(userId,
      {$pull: {"matches": matchId}},
      {safe: true, upsert: true, new: true}
    );

    return result;
  } catch (error) {
    throw error;
  }
}

// function to remove a chatroom
userSchema.statics.removeChatroom = async function (userId, chatroomId) {
  try {
    const result = await this.findByIdAndUpdate(userId,
      {$pull: {"chatrooms": chatroomId}},
      {safe: true, upsert: true, new: true}
    );

    return result;
  } catch (error) {
    throw error;
  }
}

export default mongoose.model("User", userSchema);