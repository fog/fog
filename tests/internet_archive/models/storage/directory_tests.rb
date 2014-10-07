Shindo.tests("Storage[:internet_archive] | directory", ["internetarchive"]) do

  directory_attributes = {
    :key => "fogdirectorytests-#{rand(65536)}",
    :collections => ['test_collection']
  }

  tests('success') do
    params = directory_attributes
    mocks_implemented = Fog.mocking?

    collection = Fog::Storage[:internetarchive].directories
    @instance = collection.new(params)

    tests("#save").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @instance.save
    end

    tests("#public_url").returns("http://archive.org/details/#{directory_attributes[:key]}") do
      @instance.public_url
    end

  end

  tests("#set_metadata_array_headers") do
    params = directory_attributes

    collection = Fog::Storage[:internetarchive].directories
    @instance = collection.new(params)

    @instance.collections = ['test_collection', 'opensource']
    @options = {}
    @instance.set_metadata_array_headers(:collections, @options)

    tests("#set_metadata_array_headers should set options").returns(true) do
      @options['x-archive-meta01-collection'] == 'opensource' &&
      @options['x-archive-meta02-collection'] == 'test_collection'
    end
  end

end
