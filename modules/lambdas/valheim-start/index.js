const { EC2 } = require('aws-sdk');
const ec2 = new EC2();

exports.handler = function (event, context) {
    const instanceId = process.env.instance_id;

    var params = {
        InstanceIds: [
            instanceId
        ]
    };

    ec2.startInstances(params, function (err, data) {
        if (err) {
            console.log(err, err.stack);
        } else {
            console.log(data);
        }
    });

    return context.logStreamName;
}