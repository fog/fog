Shindo.tests('Fog::Compute[:xenserver] | PBD model', ['xenserver']) do

  pbds = Fog::Compute[:xenserver].pbds
  pbd = pbds.first

  tests('The PBD model should') do
    tests('have the action') do
      test('reload') { pbd.respond_to? 'reload' }
      test('unplug') { pbd.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = pbd.attributes
      attributes = [ 
        :reference,
        :uuid,
        :__host,
        :__sr,
        :currently_attached
      ]
      tests("The PBD model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { pbd.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::PBD') { pbd.kind_of? Fog::Compute::XenServer::PBD}

  end

  tests("A real PBD should") do
    tests("return valid host") do
      test("should be a Fog::Compute::XenServer::Host") { pbd.host.kind_of? Fog::Compute::XenServer::Host }
    end
    tests("return valid storage repository") do
      test("should be a Fog::Compute::XenServer::StorageRepository") { pbd.storage_repository.kind_of? Fog::Compute::XenServer::StorageRepository }
    end
    # FIXME: find a better way (faster, lighter) to tests this
    tests("be plugged or unplugged") do
      compute = Fog::Compute[:xenserver]
      # Create a storage repository only to tests PBD.unplug
      ref = compute.create_sr compute.hosts.first.reference,
                              'FOG TEST SR',
                              'ext',
                              '',
                              { :device => '/dev/sdb' },
                              '0',
                              'user',
                              false,
                              {}
      sr = compute.storage_repositories.find { |sr| sr.name == 'FOG TEST SR' }
      pbd = sr.pbds.first
      test('plugged') do
        pbd.currently_attached == true
      end
      pbd.unplug
      pbd.reload
      test('unplugged') do
        pbd.currently_attached == false
      end
      # Clean-up
      compute.storage_repositories.each do |sr|
        next unless sr.name == 'FOG TEST SR'
        sr.pbds.each { |pbd| pbd.unplug }
        sr.destroy
      end
    end

  end

end
