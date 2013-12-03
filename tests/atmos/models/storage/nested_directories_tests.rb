Shindo.tests("Storage[:atmos] | nested directories", ['atmos']) do
  atmos = Fog::Storage[:atmos]
  tests("create a directory with a / character").succeeds do
    pending if Fog.mocking?
    atmos.directories.create(:key => 'sub/path')
  end

  tests("List of top directory returns sub dir").returns(1) do
    pending if Fog.mocking?
    atmos.directories.get('sub').directories.count
  end

  tests("create a directory in a sub dir").returns('sub/path/newdir/') do
    pending if Fog.mocking?
    atmos.directories.get('sub/path').directories.create(:key => 'newdir').identity
  end

  tests("Recursively destroy parent dir").succeeds do
    pending if Fog.mocking?
    atmos.directories.get('sub').destroy(:recursive => true)
  end

end
