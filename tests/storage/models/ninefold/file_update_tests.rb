if storage_providers.keys.include? :ninefold
  for provider, config in storage_providers

    Shindo.tests("Storage[:ninefold] | nested directories", [provider]) do
      ninefold = Fog::Storage[:ninefold]
      tests("update a file").succeeds do
        dir = ninefold.directories.create(:key => 'updatefiletests')
        f = dir.files.create(:key => 'lorem.txt', :body => lorem_file)
        f.body = "xxxxxx"
        f.save
      end
    end

  end
end
