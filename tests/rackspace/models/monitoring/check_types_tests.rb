Shindo.tests('Fog::Rackspace::Monitoring | check_types', ['rackspace','rackspace_monitoring']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::Monitoring.new

  @check_types = service.check_types

  tests('#all').succeeds do
    @check_types.all
  end
  tests('#new').succeeds do
    @check_types.new
  end

end
