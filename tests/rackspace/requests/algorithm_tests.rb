Shindo.tests('Fog::Rackspace::LoadBalancer | algorithm_tests', ['rackspace']) do

  ALGORITHMS_FORMAT = {
    'algorithms' => [
      {
        'name' => String
      }
  ]}

  @service = Fog::Rackspace::LoadBalancer.new

  tests('success') do
    tests('#list_algorithms').formats(ALGORITHMS_FORMAT) do
      @service.list_algorithms.body
    end
  end
end
