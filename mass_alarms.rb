require 'rubygems'
require 'aws-sdk'

puts "\nLoading instances..."
if File.exist?('instances.yaml')
  instances_by_id = YAML.load_file('instances.yaml')
  puts "Loaded %d instances from instances.yaml" % [instances_by_id.count]
else
  instances_by_id = Hash.new
  ec2 = AWS::EC2.new
  ec2.instances.each { |i|
    name = i.tags["Name"]
    #dns = i.dns_name
    id = i.id
    instances_by_id[id] = name
  }
  File.open('instances.yaml', 'w') { |fo| fo.write(instances_by_id.to_yaml) }
end


puts "\nLoading metrics..."
if File.exist?('metrics.yaml')
  metrics = YAML.load_file('metrics.yaml')
  puts "Loaded %d metrics from metrics.yaml" % [metrics.count]
else
  metrics = Hash.new
  cw = AWS::CloudWatch.new
  cw.metrics.each { |m|
    metric_namespace_name = m.metric_name + ":" + m.namespace
    if dimension
      metrics[metric_namespace_name] = m
    end
  }
  File.open('metrics.yaml', 'w') { |fo| fo.write(metrics.to_yaml) }
end


puts "\nAvailable metrics:"
metrics.keys.sort.each { |k| puts k }
puts "\nFor which metric are you willing to create the alarms?"
metric = gets.chomp

metric_fname = metric.delete("^a-zA-Z0-9")+'.yaml'
if File.exist?(metric_fname)
  alarms_props = YAML.load_file(metric_fname)
  puts "Loaded alarm properties from %s" % [metric_fname]
  alarms_props.each { |p|
    puts p.inspect
  }
end

if alarms_props
  puts "\nWould you like to reenter alarm properties? y/n"
  reenter = gets.chomp
end

if reenter.nil? or reenter =~ %r"y"
  alarms_props = Hash.new
  puts "\nWhat is the period (in seconds)?"
  alarms_props["period"] = gets.chomp.to_i
  puts "\nWhat is the number of evaluation periods?"
  alarms_props["evaluation_periods"] = gets.chomp.to_i
  puts "\nWhat is the statistic? SampleCount, Average, Sum, Minimum, Maximum"
  alarms_props["statistic"] = gets.chomp
  puts "\nWhat is the threshold (in percents [0-100])?"
  alarms_props["threshold"] = gets.chomp.to_f
  alarms_props["unit"] = "Percent"
  puts "\nWhat is the operator? GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold"
  alarms_props["comparison_operator"] = gets.chomp
  puts "\nWhat is the ALARM SNS Topic ARN? arn:aws:sns:us-xxxx-x:xxxxxxxxxxxx:<topic_name>"
  alarms_props["alarm_actions"] = [gets.chomp]
  File.open(metric_fname, 'w') { |fo| fo.write(alarms_props.to_yaml) }
end
puts "\nGoing to set alarms for %s metric..." % metric


cw = AWS::CloudWatch.new
cw.metrics.each { |m|
  metric_namespace_name = m.metric_name + ":" + m.namespace
  metric_name = m.metric_name
  namespace = m.namespace
  dimension = m.dimensions[0]
  if dimension and metric_namespace_name == metric and dimension[:name] = 'InstanceId'
    instance_id = dimension[:value]
    instance_name = instances_by_id[instance_id]
    if instance_name
      alarm_name = instance_name+"-"+instance_id+"-"+metric_name
      puts "Setting alarm '%s' for metric %s on instance %s (%s)" % [alarm_name, metric_namespace_name, instance_name, instance_id]

      alarms_props["metric_name"] = metric_name
      alarms_props["namespace"] = namespace
      alarms_props["alarm_description"] = "Created using MassAlarms"
      alarms_props["dimensions"] = m.dimensions
      alarm = cw.alarms.create(alarm_name, alarms_props)
      alarm.enable
    end

  end
}

puts "\nDone."
