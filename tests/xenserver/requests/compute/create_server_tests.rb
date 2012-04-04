Shindo.tests('Fog::Compute[:xenserver] | create_server request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  servers = compute.servers
  # pre-flight cleanup
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end

  tests('create_server should') do
    raises(StandardError, 'raise exception when template nil') do
      compute.create_server 'fooserver', nil
    end
    test('create a VM') do
      compute.create_server test_ephemeral_vm_name, test_template_name
      !compute.get_vm_by_name(test_ephemeral_vm_name).nil?
    end
  end
  
  tests('get_vm_by_name should') do
    test('return a valid OpaqueRef') do
      (compute.get_vm_by_name(test_template_name) =~ /OpaqueRef:/) and \
        (compute.get_vm_by_name(test_template_name) != "OpaqueRef:NULL" )
    end
    returns(nil, 'return nil if VM does not exist') { compute.get_vm_by_name('sdfsdf') }
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.create_server }
  end
end
