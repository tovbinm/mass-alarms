mass-alarms
===========

A tool for managing a large amount of AWS CloudWatch alarms


## Prerequisites
ruby, aws-sdk



## Example

Below is an example of setting a an example CPU usage alarm for one instance with condition `CPUUtilization >= 85 for 3 minutes` and check period of `60` seconds 


```
mass-alarms git:(master)$ ruby mass_alarms.rb
Loading instances...
Loaded 1 instances from instances.yaml
Loading metrics...
Loaded 43 metrics from metrics.yaml

Available metrics:
ApproximateNumberOfMessagesDelayed:AWS/SQS
ApproximateNumberOfMessagesNotVisible:AWS/SQS
ApproximateNumberOfMessagesVisible:AWS/SQS
CPUUtilization:AWS/EC2
DiskReadBytes:AWS/EC2
DiskReadOps:AWS/EC2
DiskSpaceUtilization:System/Linux
DiskWriteBytes:AWS/EC2
DiskWriteOps:AWS/EC2
EstimatedCharges:AWS/Billing
HTTPCode_Backend_2XX:AWS/ELB
HTTPCode_Backend_3XX:AWS/ELB
HTTPCode_Backend_4XX:AWS/ELB
HTTPCode_Backend_5XX:AWS/ELB
HTTPCode_ELB_4XX:AWS/ELB
HTTPCode_ELB_5XX:AWS/ELB
HealthyHostCount:AWS/ELB
Latency:AWS/ELB
MemoryUtilization:System/Linux
NetworkIn:AWS/EC2
NetworkOut:AWS/EC2
NumberOfEmptyReceives:AWS/SQS
NumberOfMessagesDeleted:AWS/SQS
NumberOfMessagesPublished:AWS/SNS
NumberOfMessagesReceived:AWS/SQS
NumberOfMessagesSent:AWS/SQS
NumberOfNotificationsDelivered:AWS/SNS
NumberOfNotificationsFailed:AWS/SNS
PublishSize:AWS/SNS
RequestCount:AWS/ELB
SentMessageSize:AWS/SQS
StatusCheckFailed:AWS/EC2
StatusCheckFailed_Instance:AWS/EC2
StatusCheckFailed_System:AWS/EC2
UnHealthyHostCount:AWS/ELB
VolumeIdleTime:AWS/EBS
VolumeQueueLength:AWS/EBS
VolumeReadBytes:AWS/EBS
VolumeReadOps:AWS/EBS
VolumeTotalReadTime:AWS/EBS
VolumeTotalWriteTime:AWS/EBS
VolumeWriteBytes:AWS/EBS
VolumeWriteOps:AWS/EBS

For which metric are you willing to create the alarms?
CPUUtilization:AWS/EC2
What is the period (in seconds)?
60
What is the number of evaluation periods?
3
What is the statistic? SampleCount, Average, Sum, Minimum, Maximum
Average
What is the threshold (in percents [0-100])?
85
What is the operator? GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold
GreaterThanOrEqualToThreshold
What is the ALARM SNS Topic ARN? arn:aws:sns:us-xxxx-x:xxxxxxxxxxxx:<topic_name>
arn:aws:sns:us-east-1:123123123123:cpu-alarms
Going to set alarms for CPUUtilization:AWS/EC2 metric...
Setting alarm 'test-i-1dababab-CPUUtilization' for metric CPUUtilization:AWS/EC2 on instance test (i-1dababab)
Done.
```
