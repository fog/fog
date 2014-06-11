Shindo.tests('Fog::Rackspace::Monitoring | alarm_examples', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?

  service = Fog::Rackspace::Monitoring.new
  alarm_example_id = 'remote.http_body_match_1'

  tests('success') do
    tests('all').succeeds do
      service.alarm_examples.all
    end
    tests('get').succeeds do
      service.alarm_examples.get(alarm_example_id)
    end
    tests('evaluate').succeeds do
      values = {'string'=> '12345'}
      service.alarm_examples.evaluate(alarm_example_id,values)
    end
  end
end
