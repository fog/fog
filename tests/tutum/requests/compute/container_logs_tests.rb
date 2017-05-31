Shindo.tests("Fog::Compute[:tutum] | container_logs request", 'tutum') do

  compute = Fog::Compute[:tutum]
  container = create_test_container

  uuid = container.uuid

  tests("Get Logs") do
    response = compute.container_logs(uuid)
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
