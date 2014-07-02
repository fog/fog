Shindo.tests('Fog::Compute[:tutum] | application_terminate request', ['tutum']) do

  compute = Fog::Compute[:tutum]
  application = compute.servers.create({ :image => "tutum/hello-world",
                                         :name => "my-awesome-app",
                                         :application_size => "XS",
                                         :target_num_applications => 2,
                                         :web_public_dns => "awesome-app.example.com" })

  tests('The response should') do
    response = compute.application_terminate(application.uuid)
    test('be a success') { response ? true: false }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when uuid option is missing') { compute.application_terminate }
  end

end
