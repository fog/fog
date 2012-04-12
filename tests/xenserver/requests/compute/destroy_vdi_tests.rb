Shindo.tests('Fog::Compute[:xenserver] | destroy_vdi request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  sr = compute.storage_repositories.find { |sr| sr.name == 'Local storage' }

  tests('destroy_vdi should') do
    ref = compute.create_vdi( { 
      :storage_repository => sr, 
      :name => 'foovdi',
      :virtual_size => '8589934592',
      :type => 'system',
      :read_only => false,
      :sharable => false,
      :other_config => {} 
    } )
    raises(Fog::XenServer::RequestFailed, 'destroy it') do
      compute.destroy_vdi ref 
      compute.vdis.get ref
    end
  end

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when vm_ref,net_ref missing') { compute.destroy_vdi }
  end
end
