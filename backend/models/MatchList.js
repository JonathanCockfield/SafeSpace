import mongoose from "mongoose";
import { v4 as uuidv4 } from "uuid";

const matchList = new mongoose.Schema(
    {
      _id: {
        type: String,
        default: () => uuidv4().replace(/\-/g, ""),
      },
      illness: {
        type: [String],
        index: true
      }
    },
    {
      timestamps: true,
      collection: "matchlist",
    }
);

matchList.statics.getNewMatch = async function (illness) {
  // finds and returns the ID of the new match
  try {
    const searchString = illness.join(' ');

    const result = await this.find(
      { $text: { $search: searchString } },
      { score: { $meta: "textScore" } }
    ).sort( { score: { $meta: "textScore" } } ).limit(1);

    return result[0];
  } catch (error) {
    throw error;
  }
}

matchList.statics.addToList = async function (_id, illness) {
  try {
    const availability = true;
    const result = await this.create({_id, illness, availability});

    return result;
  } catch (error) {
    throw error;
  }
}

matchList.statics.setAvailability = async function (_id, availability) {
  try {
    const result = await this.findOneAndUpdate({ _id: userId }, 
      { available: availability },
      {safe: true, new: true,}
    );
    return result;
  } catch (error) {
    throw error;
  }
}

export default mongoose.model("MatchList", matchList);