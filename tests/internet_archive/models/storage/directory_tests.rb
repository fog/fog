Shindo.tests("Storage[:internet_archive] | directory", ["internet_archive"]) do

  directory_attributes = {
    :key => "fogdirectorytests-#{rand(65536)}"
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

  end

end
