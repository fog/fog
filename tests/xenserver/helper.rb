def test_template_name
  'squeeze-test'
end

def test_ephemeral_vm_name
  'fog-test-server-shindo'
end

def valid_ref?(ref)
  (ref =~ /OpaqueRef:/) and \
    (ref != "OpaqueRef:NULL" )
end
