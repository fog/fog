Shindo.tests('Fog::Compute[:tutum] | application_terminate request', ['tutum']) do

  compute = Fog::Compute[:tutum]
  application = create_test_app
  tests('The response should') do
    response = compute.application_terminate(application.uuid)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises Argument when uuid is missing') { compute.application_terminate }
  end
end
