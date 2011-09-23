Shindo.tests('Fog::Rackspace::LoadBalancers | protocol_tests', ['rackspace']) do

  pending if Fog.mocking?

  PROTOCOLS_FORMAT = {
    'protocols' => [
      {
        'name' => String,
        'port' => Integer
      }
  ]}

  @service = Fog::Rackspace::LoadBalancers.new

  tests('success') do

    tests('#list_protocols').formats(PROTOCOLS_FORMAT) do
      @service.list_protocols.body
    end
  end
end
