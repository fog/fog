Shindo.tests('Fog::Compute[:ovirt] | templates collection', ['ovirt']) do

  templates = Fog::Compute[:ovirt].templates

  tests('The templates collection') do
    test('should be a kind of Fog::Compute::Ovirt::Templates') { templates.kind_of? Fog::Compute::Ovirt::Templates }
  end

end
