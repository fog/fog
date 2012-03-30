Shindo.tests('Fog::Storage[:hp] | container requests', [:hp]) do

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

  end

  tests('failure') do

    tests("#get_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].get_container('fognoncontainer')
    end

    tests("#head_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].head_container('fognoncontainer')
    end

    tests("#delete_container('fognoncontainer')").raises(Fog::Storage::HP::NotFound) do
      Fog::Storage[:hp].delete_container('fognoncontainer')
    end

  end

end