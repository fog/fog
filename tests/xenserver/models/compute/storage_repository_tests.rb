Shindo.tests('Fog::Compute[:xenserver] | StorageRepository model', ['xenserver']) do

  storage_repositories = Fog::Compute[:xenserver].storage_repositories
  storage_repository = storage_repositories.first

  tests('The StorageRepository model should') do
    tests('have the action') do
      test('reload') { storage_repository.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = storage_repository.attributes
      attributes = [ 
        :reference,
        :name,
        :uuid,
        :description,
        :uuid,
        :allowed_operations,
        :current_operations,
        :content_type,
        :other_config,
        :__pbds,
        :shared,
        :type,
        :tags,
        :__vdis,
        :physical_size,
        :physical_utilisation
      ]
      tests("The StorageRepository model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { storage_repository.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::StorageRepository') { storage_repository.kind_of? Fog::Compute::XenServer::StorageRepository }

  end

  tests("A real StorageRepository should") do
    tests("return a valid list of VDIs") do
      storage_repository.vdis.each do |vdi| 
        test("where #{vdi.uuid} is a Fog::Compute::XenServer::VDI") {
          vdi.is_a? Fog::Compute::XenServer::VDI
        }
      end
    end
    tests("return a valid list of PBDs") do
      storage_repository.pbds.each do |pbd| 
        test("where #{pbd.uuid} is a Fog::Compute::XenServer::PBD") {
          pbd.is_a? Fog::Compute::XenServer::PBD
        }
      end
    end
  end

end
