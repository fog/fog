Shindo.tests('Fog::Compute[:tutum] | application model', ['tutum']) do

  compute = Fog::Compute[:tutum]
  application = compute.applications.create(:name => "fog-#{Time.now.to_i}", 'image' => 'ubuntu','Cmd' => ['date'])

  tests('The application model should') do
    tests('have the action') do
      test('reload') { application.respond_to? 'reload' }
      %w{ start restart stop destroy}.each do |action|
        test(action) { application.respond_to? action }
      end
      %w{ start restart stop destroy}.each do |action|
        test("#{action} returns successfully") {
          application.send(action.to_sym) ? true : false
        }
      end
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
                     :public_dns,
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
