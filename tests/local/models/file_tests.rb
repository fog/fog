Shindo.tests('Storage[:local] | file', ["local"]) do

  pending if Fog.mocking?

  before do
    @options = { :local_root => '~/.fog' }
  end

  tests('#public_url') do
    tests('when connection has an endpoint').
      returns('http://example.com/files/directory/file.txt') do
        @options[:endpoint] = 'http://example.com/files'

        connection = Fog::Storage::Local.new(@options)
        directory = connection.directories.new(:key => 'directory')
        file = directory.files.new(:key => 'file.txt')

        file.public_url
      end

    tests('when connection has no endpoint').
      returns(nil) do
        @options[:endpoint] = nil

        connection = Fog::Storage::Local.new(@options)
        directory = connection.directories.new(:key => 'directory')
        file = directory.files.new(:key => 'file.txt')

        file.public_url
      end

    tests('when file path has escapable characters').
      returns('http://example.com/files/my%20directory/my%20file.txt') do
        @options[:endpoint] = 'http://example.com/files'

        connection = Fog::Storage::Local.new(@options)
        directory = connection.directories.new(:key => 'my directory')
        file = directory.files.new(:key => 'my file.txt')

        file.public_url
      end
  end
end
