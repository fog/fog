Shindo.tests('Fog::Rackspace::LoadBalancer', ['rackspace']) do

  @service = Fog::Rackspace::LoadBalancer.new

  tests('#algorithms').succeeds do
    data = @service.algorithms
    returns(true) { data.is_a? Array }
    returns(true) { data.first.is_a? String }
  end

  tests('#protocols').succeeds do
    data = @service.protocols
    returns(true) { data.is_a? Array }
  end

  tests('#usage').succeeds do
    @service.usage
  end
end
