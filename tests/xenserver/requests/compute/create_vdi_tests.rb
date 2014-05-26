Shindo.tests('Fog::Compute[:xenserver] | create_vdi request', ['xenserver']) do

  compute = Fog::Compute[:xenserver]
  sr = compute.storage_repositories.find { |sr| sr.name == 'Local storage' }

  tests('create_vdi should') do
    raises(ArgumentError, 'raise ArgumentError if virtual_size is no specified') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :type => 'system',
        :read_only => false,
        :sharable => false,
        :other_config => {}
      } )
    end
    raises(ArgumentError, 'raise ArgumentError if type is no specified') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :virtual_size => '8589934592',
        :read_only => false,
        :sharable => false,
        :other_config => {}
      } )
      valid_ref? ref
    end
    raises(ArgumentError, 'raise ArgumentError if read_only is no specified') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :virtual_size => '8589934592',
        :type => 'system',
        :sharable => false,
        :other_config => {}
      } )
      valid_ref? ref
    end
    raises(ArgumentError, 'raise ArgumentError if sharable is no specified') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :virtual_size => '8589934592',
        :type => 'system',
        :read_only => false,
        :other_config => {}
      } )
      valid_ref? ref
    end
    raises(ArgumentError, 'raise ArgumentError if other_config is no specified') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :virtual_size => '8589934592',
        :type => 'system',
        :read_only => false,
        :sharable => false,
      } )
      valid_ref? ref
    end
    test('create a VDI') do
      ref = compute.create_vdi( {
        :storage_repository => sr,
        :name => 'foovdi',
        :virtual_size => '8589934592',
        :type => 'system',
        :read_only => false,
        :sharable => false,
        :other_config => {}
      } )
      valid_ref? ref
    end
  end

  compute.vdis.each { |vdi| vdi.destroy if vdi.name == 'foovdi' }

  tests('The expected options') do
    raises(ArgumentError, 'raises ArgumentError when vm_ref,net_ref missing') { compute.create_vdi }
  end
end
