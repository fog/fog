Shindo.tests("Fog::Storage[:hp] | container requests", ['hp']) do

  @container_format = [String]

  @containers_format = [{
    'bytes' => Integer,
    'count' => Integer,
    'name'  => String
  }]

  tests('success') do

    tests("#put_container('fogcontainertests')").succeeds do
      Fog::Storage[:hp].put_container('fogcontainertests')
    end

    tests("#post_container('fogcontainertests', {'X-Container-Meta-Foo' => 'foometa'})").succeeds do
      Fog::Storage[:hp].post_container('fogcontainertests', {'X-Container-Meta-Foo' => 'foometa'})
    end

    tests("#get_container('fogcontainertests')").formats(@container_format) do
      Fog::Storage[:hp].get_container('fogcontainertests').body
    end

    tests("#get_containers").formats(@containers_format) do
      Fog::Storage[:hp].get_containers.body
    end

    tests("#head_container('fogcontainertests')").succeeds do
      Fog::Storage[:hp].head_container('fogcontainertests')
    end

    tests("#head_containers").succeeds do
      Fog::Storage[:hp].head_containers
    end

    tests("#delete_container('fogcontainertests')").succeeds do
      Fog::Storage[:hp].delete_container('fogcontainertests')
    end

    tests("#put_container('fogacltests', {'X-Container-Read' => 'private'})").succeeds do
      Fog::Storage[:hp].put_container('fogacltests', {'X-Container-Read' => 'private'})
    end
    Fog::Storage[:hp].delete_container('fogacltests')

    tests("#put_container('fogacltests', {'X-Container-Read' => 'public-read'})").succeeds do
      Fog::Storage[:hp].put_container('fogacltests', {'X-Container-Read' => 'public-read'})
    end
    Fog::Storage[:hp].delete_container('fogacltests')

    tests("#put_container('fogacltests', {'X-Container-Read' => 'invalid'})").succeeds do
      Fog::Storage[:hp].put_container('fogacltests', {'X-Container-Read' => 'invalid'})
    end
    Fog::Storage[:hp].delete_container('fogacltests')

  end

  tests('failure') do

    tests("#get_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_container('fognoncontainer')
    end

    tests("#post_container('fognoncontainer', {})").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].post_container('fognoncontainer', {})
    end

    tests("#head_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].head_container('fognoncontainer')
    end

    tests("#delete_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].delete_container('fognoncontainer')
    end

    @container = Fog::Storage[:hp].directories.create(:key => 'fognonempty')
    @file = @container.files.create(:key => 'foo', :body => 'bar')
    tests("#delete_container('fognonempty')").raises(Excon::Errors::Conflict) do
      Fog::Storage[:hp].delete_container('fognonempty')
    end
    @file.destroy
    @container.destroy

  end

end
