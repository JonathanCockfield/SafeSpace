import '@tensorflow/tfjs-node';
import * as toxicity from '@tensorflow-models/toxicity';


export default {

    predict: async (message) =>
    {

        var res = [];

        const threshold = 0.83;

        const model = await toxicity.default.load(threshold);

        const predictions = await model.classify([message]);

        console.log(predictions);

        for(var i = 0; i < predictions.length; i++)
        {
            // threat predictions are more leninent to be labelled 
            if(i == 5)
            {
                if(predictions[i].results[0].probabilities[1] >= 0.7)
                {
                    res.push(predictions[i].label);
                }
            }
            else if(predictions[i].results[0].match)
            {
                res.push(predictions[i].label);
            }
        }

        return Array.from(res);

    }
}



