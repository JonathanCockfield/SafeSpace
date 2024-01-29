import '@tensorflow/tfjs-node';
import * as toxicity from '@tensorflow-models/toxicity';


export default {

    predict: async (message) =>
    {

        var res = [];

        const model = await toxicity.load();

        const predictions = await model.classify([message]);

        for(var i = 0; i < predictions.length; i++)
        {
            if(predictions[i].results[0].match)
            {
                res.push(predictions[i].label);
            }
        }
        
        return res;

    }
}



