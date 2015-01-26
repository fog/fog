Shindo.tests('Fog::Storage[:rackspace] | container requests', ["rackspace"]) do

  @container_format = [{
    'hash' => String,
    'last_modified' => String,
    'bytes' => Integer,
    'name' => String,
    'content_type' => String
  }]

  @containers_format = [{
    'bytes' => Integer,
    'count' => Integer,
    'name'  => String
  }]

  tests('success') do

    tests("#put_container('fogcontainertests', {})").succeeds do
      Fog::Storage[:rackspace].put_container('fogcontainertests')
    end

    tests("#put_container('fogcontainertests', 'X-Container-Meta-Color'=>'green')").succeeds do
      Fog::Storage[:rackspace].put_container('fogcontainertests', 'X-Container-Meta-Color'=>'green')
      response = Fog::Storage[:rackspace].head_container('fogcontainertests')
      returns('green') { response.headers['X-Container-Meta-Color'] }
    end

    tests("#get_container('fogcontainertests')").formats(@container_format) do
      Fog::Storage[:rackspace].get_container('fogcontainertests').body
    end

    tests("#get_containers").formats(@containers_format) do
      Fog::Storage[:rackspace].get_containers.body
    end

    tests("#head_container('fogcontainertests')").succeeds do
      Fog::Storage[:rackspace].head_container('fogcontainertests')
    end

    tests("#head_containers").succeeds do
      Fog::Storage[:rackspace].head_containers
    end

    tests("#delete_container('fogcontainertests')").succeeds do
      Fog::Storage[:rackspace].delete_container('fogcontainertests')
    end

  end

  tests('failure') do

    tests("#get_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].get_container('fognoncontainer')
    end

    tests("#head_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].head_container('fognoncontainer')
    end

    tests("#delete_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      Fog::Storage[:rackspace].delete_container('fognoncontainer')
    end

  end

end
