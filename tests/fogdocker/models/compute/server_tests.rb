Shindo.tests('Fog::Compute[:fogdocker] | server model', ['fogdocker']) do

  compute = Fog::Compute[:fogdocker]
  server = compute.servers.create(:name => "fog-#{Time.now.to_i}", 'image' => 'mattdm/fedora:f19','Cmd' => ['date'])

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ start restart stop commit destroy}.each do |action|
        test(action) { server.respond_to? action }
      end
      %w{ start restart stop commit destroy}.each do |action|
        test("#{action} returns successfully") {
          server.send(action.to_sym) ? true : false
        }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ :id,
                     :name,
                     :created,
                     :ipaddress,
                     :state_running,
                     :memory,
                     :cores,
                     :cpu_shares,
                     :hostname,
                     :image,
                     :attach_stdin,
                     :attach_stdout,
                     :attach_stderr,
                     :state_exit_code,
                     :state_pid,
                     :port_bindings,
                     :links,
                     :privileged,
                     :tty,
                     :exposed_ports,
                     :volumes,
                     :environment_variables
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
    test('be a kind of Fog::Compute::Fogdocker::Server') { server.kind_of? Fog::Compute::Fogdocker::Server }
  end

end
