Shindo.tests('Fog::Rackspace::Storage | directories', ['rackspace']) do

  @service = Fog::Storage[:rackspace]

  begin
    @name = "fog-directories-test-#{Time.now.to_i.to_s}"
    @filename = 'lorem.txt'
    @dir = @service.directories.create :key => @name, :metadata => {:fog_test => true}
    @file = @dir.files.create :key => @filename, :body => lorem_file

    tests('#get').succeeds do
      instance = @service.directories.get @name
      returns(false) { instance.nil? }
      returns('true') { instance.metadata[:fog_test] }
      returns(@name) { instance.key }
      returns(1) { instance.count }
      returns( Fog::Storage.get_body_size(lorem_file)) {instance.bytes }
      returns(@filename) { instance.files.first.key }
    end

  ensure
    @file.destroy if @file
    @dir.destroy if @dir
  end

end
