if storage_providers.keys.include? :ninefold
  for provider, config in storage_providers

    Shindo.tests("Storage[:ninefold] | nested directories", [provider]) do
      ninefold = Fog::Storage[:ninefold]
      tests("create a directory with a / character").succeeds do
        ninefold.directories.create(:key => 'sub/path')
      end

      tests("List of top directory returns sub dir").returns(1) do
        ninefold.directories.get('sub').directories.count
      end

      tests("create a directory in a sub dir").returns('sub/path/newdir/') do
        ninefold.directories.get('sub/path').directories.create(:key => 'newdir').identity
      end

      tests("Recursively destroy parent dir").succeeds do
        ninefold.directories.get('sub').destroy(:recursive => true)
      end

    end

  end
end
