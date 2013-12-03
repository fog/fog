Shindo.tests('Storage[:local] | directory', ["local"]) do

  pending if Fog.mocking?

  before do
    @options = { :local_root => '~/.fog' }
  end

  tests('save') do
    returns(true) do
      connection = Fog::Storage::Local.new(@options)
      connection.directories.create(:key => 'directory')
      connection.directories.create(:key => 'directory')
    end
  end
end
