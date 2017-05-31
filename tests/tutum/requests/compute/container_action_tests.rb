Shindo.tests("Fog::Compute[:tutum] | container_action request", 'tutum') do

  compute = Fog::Compute[:tutum]
  container = create_test_container

  uuid = container.uuid

  tests("Start Container") do
    response = compute.container_action(uuid, 'start' )
    test("should be a kind of Hash") { response.kind_of?  Hash}
    wait_for_container(uuid, "Running")
  end

  tests("Stop Container") do
    response = compute.container_action(uuid, 'stop' )
    test("should be a kind of Hash") { response.kind_of? Hash}
    wait_for_container(uuid, "Stopped")
  end

  tests("Redeploy Container") do
    response = compute.container_action(uuid,'redeploy', {:tag => "latest"} )
    test("should be a kind of Hash") { response.kind_of? Hash}
    wait_for_container(uuid, "Terminated")
    test("New container should be returned") { response["uuid"] != uuid }
    wait_for_container(response["uuid"], "Running")
  end
end
