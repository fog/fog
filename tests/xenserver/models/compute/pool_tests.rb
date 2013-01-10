Shindo.tests('Fog::Compute[:xenserver] | Pool model', ['xenserver']) do

  pools = Fog::Compute[:xenserver].pools
  pool = pools.first

  tests('The Pool model should') do
    tests('have the action') do
      test('reload') { pool.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = pool.attributes
      attributes = [ 
        :reference,
        :uuid,
        :name,
        :description,
        :__default_sr,
        :__master,
        :tags,
        :restrictions,
        :ha_enabled,
        :vswitch_controller,
        :__suspend_image_sr
      ]
      tests("The Pool model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { pool.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::Pool') { pool.kind_of? Fog::Compute::XenServer::Pool}

  end

  tests("A real Pool should") do
    tests("return a valid default_storage_repository") do
      test("should be a Fog::Compute::XenServer::StorageRepository") { pool.default_storage_repository.kind_of? Fog::Compute::XenServer::StorageRepository }
    end
    tests("return valid Host as the master") do
      test("should be a Fog::Compute::XenServer::Host") { pool.master.kind_of? Fog::Compute::XenServer::Host }
    end
    test("be able to be configured as a valid suspend_image_sr") do
      pool.suspend_image_sr = pool.default_storage_repository
      pool.reload
      pool.suspend_image_sr.reference == pool.default_storage_repository.reference
    end

  end

end
