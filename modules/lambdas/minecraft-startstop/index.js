const { EC2 } = require('aws-sdk');
const ec2 = new EC2();

exports.handler = function (event, context) {
    const start = event['status'] === "Start" ? true : false;
    const instanceId = process.env.instance_id;

    var params = {
        InstanceIds: [
            instanceId
        ]
    };

    if (start) {
        ec2.startInstances(params, function (err, data) {
            if (err) {
                console.log(err, err.stack);
            } else {
                console.log(data);
            }
        });

    } else {
        ec2.stopInstances(params, function (err, data) {
            if (err) {
                console.log(err, err.stack);
            } else {
                console.log(data);
            }
        });
    }


    return context.logStreamName;
}