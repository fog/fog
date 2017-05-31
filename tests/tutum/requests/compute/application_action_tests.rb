Shindo.tests("Fog::Compute[:tutum] | application_action request", 'tutum') do
  compute = Fog::Compute[:tutum]
  application = create_test_app
  uuid = application.uuid
  
  tests("Start Application") do
    response = compute.application_action(uuid, 'start')
    test("should be a kind of Hash") { response.kind_of?  Hash}
    wait_for_application(uuid, "Running")
  end

  tests("Stop Application") do
    response = compute.application_action(uuid, 'stop')
    test("should be a kind of Hash") { response.kind_of? Hash}
     wait_for_application(uuid, "Stopped")
  end

  tests("Redeploy Application") do
    response = compute.application_action(uuid,'redeploy',{:tag => "latest"} )
    test("should be a kind of Hash") { response.kind_of? Hash}
    wait_for_application(uuid, "Running")
  end
end
