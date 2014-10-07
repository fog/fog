def test_template_name
  ENV['FOG_XENSERVER_TEMPLATE'] || 'squeeze-test'
end

def test_ephemeral_vm_name
  'fog-test-server-shindo'
end

def valid_ref?(ref)
  (ref =~ /OpaqueRef:/) and \
    (ref != "OpaqueRef:NULL" )
end

def create_ephemeral_vm
  Fog::Compute[:xenserver].servers.create(:name => test_ephemeral_vm_name,
                                          :template_name => test_template_name)
end

def create_ephemeral_server
  create_ephemeral_vm
end

def destroy_ephemeral_servers
  servers = Fog::Compute[:xenserver].servers
  # Teardown cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end
  (servers.templates.select { |t| t.name == test_ephemeral_vm_name}).each do |s|
    s.destroy
  end
end

def destroy_ephemeral_vms
  destroy_ephemeral_servers
end
