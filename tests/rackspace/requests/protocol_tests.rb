Shindo.tests('Fog::Rackspace::LoadBalancers | protocol_tests', ['rackspace']) do

  PROTOCOLS_FORMAT = {
    'protocols' => [
      {
        'name' => String,
        'port' => Integer
      }
  ]}

  @service = Fog::Rackspace::LoadBalancer.new

  tests('success') do

    tests('#list_protocols').formats(PROTOCOLS_FORMAT) do
      @service.list_protocols.body
    end
  end
end
