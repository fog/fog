Shindo.tests('Storage[:local] | directories', ["local"]) do

  pending if Fog.mocking?

  @options = { :local_root => "/tmp/fogtests" }
  @collection = Fog::Storage::Local.new(@options).directories

  collection_tests(@collection, {:key => "fogdirtests"}, true)

  tests("#all") do
    tests("succeeds when :local_root does not exist").succeeds do
      FileUtils.rm_rf(@options[:local_root])
      @collection.all
    end
  end

end
