Shindo.tests("Storage[:atmos] | directory", ["atmos"]) do

  directory_attributes = {
    :key => 'fogdirectorytests'
  }

  model_tests(Fog::Storage[:atmos].directories, directory_attributes, Fog.mocking?) do

    tests("#directory_lifecycle") do
      tests("creates a directory, puts files in it, destroys it").returns(true) do
        directory = Fog::Storage[:atmos].directories.create(:key => 'directory_test')
        return false if directory.nil?
        10.times do |id|
          ret = directory.connection.put_object(directory.key, "#{@instance.key}-#{id}", 'test')
          return false if !ret
        end
        directory.destroy(:recursive => true)
      end
    end

  end

end
