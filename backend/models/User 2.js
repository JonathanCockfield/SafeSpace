  import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";

export const USER_TYPES = {
  CONSUMER: "mentor",
  SUPPORT: "mentee",
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
    age: Number,
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

// function will return all users as type
userSchema.statics.getUsers = async function () {
  try {
    const users = await this.find();
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

export default mongoose.model("User", userSchema);