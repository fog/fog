Shindo.tests('Fog::Compute[:xenserver] | clone_server request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  servers = compute.servers
  (servers.all :name_matches => test_ephemeral_vm_name).each do |s|
    s.destroy
  end

  tests('clone_server should') do
    raises(ArgumentError, 'raise exception when template nil') do
      compute.clone_server 'fooserver', nil
    end
    raises(ArgumentError, 'raise exception when name nil') do
      compute.clone_server nil, 'fooref'
    end

    compute.default_template = test_template_name
    tmpl = compute.default_template
    test('accept a string template ref') do
      ref = compute.clone_server test_ephemeral_vm_name, tmpl.reference
      (ref =~ /OpaqueRef:/) == 0 and !(servers.custom_templates.find { |s| s.reference == ref }).nil?
    end
    test('accept a Server object') do
      ref = compute.clone_server test_ephemeral_vm_name, tmpl
      (ref =~ /OpaqueRef:/) == 0 and !(servers.custom_templates.find { |s| s.reference == ref }).nil?
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when ref,class missing') { compute.clone_server }
  end
end
