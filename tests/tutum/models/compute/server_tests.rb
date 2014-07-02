Shindo.tests('Fog::Compute[:tutum] | server model', ['tutum']) do

  compute = Fog::Compute[:tutum]
  server = compute.servers.create(:name => "fog-#{Time.now.to_i}", :image => 'ubuntu',:cmd => ['date'])

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ start restart stop destroy}.each do |action|
        test(action) { server.respond_to? action }
      end
      %w{ start restart stop destroy}.each do |action|
        test("#{action} returns successfully") {
          server.send(action.to_sym) ? true : false
        }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ :uuid,
                     :application,
                     :autodestroy,
                     :autoreplace,
                     :autorestart,
                     :container_envvars,
                     :container_ports,
                     :container_size,
                     :deployed_datetime,
                     :destroyed_datetime,
                     :entrypoint,
                     :exit_code,
                     :exit_code_msg,
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
                     :started_datetime,
                     :state,
                     :stopped_datetime,
                     :unique_name
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Tutum::Server') { server.kind_of? Fog::Compute::Tutum::Server }
  end

end
