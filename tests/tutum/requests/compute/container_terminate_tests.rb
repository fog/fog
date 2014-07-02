Shindo.tests('Fog::Compute[:tutum] | container_terminate request', ['tutum']) do

  compute = Fog::Compute[:tutum]
  container = compute.servers.create({ :image => "tutum/hello-world",
                                       :name => "my-awesome-app",
                                       :container_size => "XS",
                                       :web_public_dns => "awesome-app.example.com" })

  tests('The response should') do
    response = compute.container_terminate(container.uuid)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when uuid option is missing') { compute.container_terminate }
  end

end
