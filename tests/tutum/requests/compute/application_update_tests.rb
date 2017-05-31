Shindo.tests("Fog::Compute[:tutum] | application_update request", 'tutum') do

  compute = Fog::Compute[:tutum]
  application = create_test_app
  application.start
  
  tests("Update Application") do
    wait_for_application(application.uuid, "Running")
    response = compute.application_update(application.uuid, {:target_num_containers => 3} )
    test("should be a kind of Hash") { response.kind_of?  Hash}
  end
end
