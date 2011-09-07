Shindo.tests('Fog::Rackspace::LoadBalancers | algorithm_tests', ['rackspace']) do

  pending if Fog.mocking?

  ALGORITHMS_FORMAT = {
    'algorithms' => [
      {
        'name' => String
      }
  ]}

  @service = Fog::Rackspace::LoadBalancers.new

  tests('success') do
    tests('#list_algorithms').formats(ALGORITHMS_FORMAT) do
      @service.list_algorithms.body
    end
  end
end
