var { EC2, Route53 } = require('aws-sdk');
const ec2 = new EC2();
const route53 = new Route53();

exports.handler = function (event, context) {
    const hostedZoneId = process.env.hosted_zone_id;
    const recordName = process.env.record_name;

    const ec2Params = {
        InstanceIds: [
            event['detail']['instance-id']
        ]
    };

    ec2.describeInstances(ec2Params, function (err, data) {
        if (err) {
            console.error(err.stack);
        }

        const ip = data.Reservations?.[0].Instances?.[0].PublicIpAddress;

        if (hostedZoneId && recordName && ip) {
            const dnsParams = {
                ChangeBatch: {
                    Changes: [{
                        Action: 'UPSERT',
                        ResourceRecordSet: {
                            Name: recordName,
                            ResourceRecords: [{
                                Value: ip
                            }],
                            TTL: 60,
                            Type: 'A'
                        }
                    }],
                    Comment: "Updating"
                },
                HostedZoneId: hostedZoneId
            }
            route53.changeResourceRecordSets(dnsParams, function (err, data) {
                if (err) {
                    console.log(err, err.stack);
                } else {
                    console.log(data);
                }
            });
        } else {
            console.error("Missing a parameter");
        }
    });
    return context.logStreamName;
}