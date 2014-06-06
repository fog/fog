Shindo.tests("Storage[:ninefold] | nested directories", ['ninefold']) do

  unless Fog.mocking?
    @directory = Fog::Storage[:ninefold].directories.create(:key => 'updatefiletests')
  end

  ninefold = Fog::Storage[:ninefold]
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
