Shindo.tests('Fog::Compute[:libvirt] | volume model', ['libvirt']) do

  volume = Fog::Compute[:libvirt].servers.all.select{|v| v.name !~ /^fog/}.first.volumes.first

  tests('The volume model should') do
    tests('have attributes') do
      model_attribute_hash = volume.attributes
      attributes = [ :id,
        :pool_name,
        :key,
        :name,
        :path,
        :capacity,
        :allocation,
        :format_type]
      tests("The volume model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { volume.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Volume') { volume.kind_of? Fog::Compute::Libvirt::Volume }
  end

  tests('Cloning volumes should') do
    test('respond to clone_volume') { volume.respond_to? :clone_volume }
    new_vol = volume.clone_volume('new_vol')
    # We'd like to test that the :name attr has changed, but it seems that's
    # not possible, so we can at least check the new_vol xml exists properly
    test('succeed') { volume.xml == new_vol.xml }
  end

end
