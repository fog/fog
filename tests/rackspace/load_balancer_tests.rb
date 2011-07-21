Shindo.tests('Fog::Rackspace::LoadBalancer', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new
  tests('#algorithms').succeeds do
    data = @service.algorithms
    returns(true) { data.is_a? Array }
    returns(true) { data.first.is_a? String }
  end
end
