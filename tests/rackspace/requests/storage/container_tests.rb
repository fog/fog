Shindo.tests('Fog::Storage[:rackspace] | container requests', [:rackspace]) do

  @container_format = [String]

  @containers_format = [{
    'bytes' => Integer,
    'count' => Integer,
    'name'  => String
  }]

  tests('success') do

    tests("#put_container('fogcontainertests')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].put_container('fogcontainertests')
    end

    tests("#get_container('fogcontainertests')").formats(@container_format) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_container('fogcontainertests').body
    end

    tests("#get_containers").formats(@containers_format) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_containers.body
    end

    tests("#head_container('fogcontainertests')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_container('fogcontainertests')
    end

    tests("#head_containers").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_containers
    end

    tests("#delete_container('fogcontainertests')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_container('fogcontainertests')
    end

  end

  tests('failure') do

    tests("#get_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].get_container('fognoncontainer')
    end

    tests("#head_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].head_container('fognoncontainer')
    end

    tests("#delete_container('fognoncontainer')").raises(Fog::Storage::Rackspace::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:rackspace].delete_container('fognoncontainer')
    end

  end

end