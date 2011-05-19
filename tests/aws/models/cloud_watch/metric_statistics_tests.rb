Shindo.tests("AWS::CloudWatch | metric_statistics", ['aws', 'cloudwatch']) do

  tests('success') do
    pending if Fog.mocking?
    
    instanceId = 'i-420c352f'
    metricName = 'DiskReadBytes'
    namespace = 'AWS/EC2'
    startTime = (Time.now-600).iso8601
    endTime = Time.now.iso8601
    period = 60
    statisticTypes = ['Minimum','Maximum','Sum','SampleCount','Average']
    
    tests("#all").succeeds do
      @statistics = AWS[:cloud_watch].metric_statistics.all({'Statistics' => statisticTypes, 'StartTime' => startTime, 'EndTime' => endTime, 'Period' => period, 'MetricName' => metricName, 'Namespace' => namespace, 'Dimensions' => [{'Name' => 'InstanceId', 'Value' => instanceId}]}))    end
    
    tests("#all_not_empty").returns(true) do
      @statistics.length > 0
    end
    
  end

end