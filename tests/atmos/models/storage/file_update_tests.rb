Shindo.tests("Storage[:atmos] | nested directories", ['atmos']) do

  unless Fog.mocking?
    @directory = Fog::Storage[:atmos].directories.create(:key => 'updatefiletests')
  end

  atmos = Fog::Storage[:atmos]
  tests("update a file").succeeds do
    pending if Fog.mocking?
    file = @directory.files.create(:key => 'lorem.txt', :body => lorem_file)
    file.body = "xxxxxx"
    file.save
  end

  unless Fog.mocking?
    @directory.destroy(:recursive => true)
  end

end
