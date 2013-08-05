Shindo.tests('Fog::Rackspace::Monitoring | alarm_example', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?

  service = Fog::Rackspace::Monitoring.new
  alarm_example_id = 'remote.http_body_match_1'
  alarm = service.alarm_examples.get(alarm_example_id)

  tests('#bound?') do
    tests('should return false if not bound') do
      returns(false) {alarm.bound?}
    end
    tests('should return true if bound') do
      values = {'string' => '12345'}
      alarm = service.alarm_examples.evaluate(alarm_example_id,values)
      returns(true) {alarm.bound?}
    end
  end
end
