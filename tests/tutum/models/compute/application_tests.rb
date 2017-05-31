Shindo.tests('Fog::Compute[:tutum] | application model', ['tutum']) do

  compute = Fog::Compute[:tutum]
  application = create_test_app

  tests('The application model should') do
    tests('have the action') do
      %w{ start reload stop destroy redeploy }.each do |action|
        test(action) { application.respond_to? action }
      end
    end
    test("start") do |a|
      application.start
      wait_for_application(application.uuid, "Running")
    end

    test("reload") do |a|
      !application.reload.nil?
    end

    test("redeploy") do |a|
      application.redeploy
      wait_for_application(application.uuid, "Running")
    end

    test("stop") do |a|
      application.stop
      wait_for_application(application.uuid, "Stopped")
    end

    test("destroy") do |a|
      application.destroy
      wait_for_application(application.uuid, "Terminated")
    end

    tests('have attributes') do
      model_attribute_hash = application.attributes
      attributes = [ :uuid,
                     :autodestroy,
                     :autoreplace,
                     :autorestart,
                     :container_envvars,
                     :container_ports,
                     :container_size,
                     :containers,
                     :current_num_containers,
                     :deployed_datetime,
                     :destroyed_datetime,
                     :entrypoint,
                     :image_name,
                     :image_tag,
                     :link_variables,
                     :linked_from_application,
                     :linked_to_application,
                     :linked_from_container,
                     :linked_to_container,
                     :name,
                     :resource_uri,
                     :roles,
                     :run_command,
                     :running_num_containers,
                     :sequential_deployment,
                     :started_datetime,
                     :state,
                     :stopped_datetime,
                     :stopped_num_containers,
                     :target_num_containers,
                     :unique_name,
                     :web_public_dns
      ]
      tests("The application model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { application.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Tutum::Application') { application.kind_of? Fog::Compute::Tutum::Application }
  end

end
