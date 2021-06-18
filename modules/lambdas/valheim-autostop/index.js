const { EC2 } = require('aws-sdk');
const ec2 = new EC2();

exports.handler = function (event, context) {
    const instanceId = process.env.instance_id;
    const recordName = process.env.record_name;

    https.get(recordName, res => {
        res.setEncoding("utf8");
        let body = "";
        res.on("data", data => {
            body += data;
        });
        res.on("end", () => {
            body = JSON.parse(body);
            if (body.player_count === 0) {
                var params = {
                    InstanceIds: [
                        instanceId
                    ]
                };

                ec2.stopInstances(params, function (err, data) {
                    if (err) {
                        console.log(err, err.stack);
                    } else {
                        console.log(data);
                    }
                });
            } else {
                console.log("Players online, skipping auto-shutdown.")
            }
        });
    });
    return context.logStreamName;
}