Shindo.tests('Fog::Compute[:fogdocker] | api_version request', ['fogdocker']) do

  compute = Fog::Compute[:fogdocker]

  tests('The response should') do
    response = compute.api_version()
    test('be a Hash') { response.kind_of? Hash}
  end

end
