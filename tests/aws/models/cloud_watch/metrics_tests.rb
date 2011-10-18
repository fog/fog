Shindo.tests("AWS::CloudWatch | metrics", ['aws', 'cloudwatch']) do

  tests('success') do
    pending # FIXME: the hardcoded instance id won't be available
    tests("#all").succeeds do
      Fog::AWS[:cloud_watch].metrics.all
    end
    instanceId = 'i-fd713391'
    metricName = 'CPUUtilization'
    namespace = 'AWS/EC2'
    tests("#get").returns({:dimensions=>[{"Name"=>"InstanceId", "Value"=>instanceId}], :name=>metricName, :namespace=>namespace}) do
      Fog::AWS[:cloud_watch].metrics.get(namespace, metricName, {'InstanceId' => instanceId}).attributes
    end
    
  end

end