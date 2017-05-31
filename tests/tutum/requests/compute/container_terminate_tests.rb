Shindo.tests('Fog::Compute[:tutum] | container_terminate request', ['tutum']) do

  compute = Fog::Compute[:tutum]
  container = create_test_container

  tests('The response should') do
    response = compute.container_terminate(container.uuid)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when uuid option is missing') { compute.container_terminate }
  end
end