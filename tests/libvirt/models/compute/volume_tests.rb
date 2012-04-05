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
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Libvirt::Volume') { volume.kind_of? Fog::Compute::Libvirt::Volume }
  end

end
