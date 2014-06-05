Shindo.tests('Fog::Compute[:xenserver] | StorageRepositories collection', ['xenserver']) do

  conn = Fog::Compute[:xenserver]

  tests('The storage_repositories collection') do
    storage_repositories = conn.storage_repositories.all

    test('should not be empty') { !storage_repositories.empty? }

    test('should be a kind of Fog::Compute::XenServer::StorageRepositories') { storage_repositories.kind_of? Fog::Compute::XenServer::StorageRepositories }

    tests('should be an array of Fog::Compute::XenServer::StorageRepository') do
      storage_repositories.each do |p|
        test("#{p.uuid} is a Fog::Compute::XenServer::StorageRepository") {
          p.is_a? Fog::Compute::XenServer::StorageRepository
        }
      end
    end

    tests('should be able to reload itself').succeeds { storage_repositories.reload }

    tests('should be able to get a model') do
      tests('by reference').succeeds {
        storage_repositories.get(storage_repositories.first.reference).is_a? Fog::Compute::XenServer::StorageRepository
      }
    end

  end

end
