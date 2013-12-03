Shindo.tests("Fog::CDN[:hp] | container requests", ['hp']) do

  @cdn_containers_format = [{
    'x-cdn-ssl-uri' => String,
    'cdn_enabled'   => Fog::Boolean,
    'name'          => String,
    'x-cdn-uri'     => String,
    'ttl'           => Integer,
    'log_retention' => Fog::Boolean
  }]

  tests('success') do

    tests("#put_container('fogcdncontainertests')").succeeds do
      Fog::CDN[:hp].put_container('fogcdncontainertests')
    end

    tests("duplicate #put_container('fogcdncontainertests')").succeeds do
      Fog::CDN[:hp].put_container('fogcdncontainertests')
    end

    tests("#get_containers").formats(@cdn_containers_format) do
      Fog::CDN[:hp].get_containers.body
    end

    tests("#post_container('fogcdncontainertests', {'x-ttl' => 3200})").succeeds do
      Fog::CDN[:hp].post_container('fogcdncontainertests', {'x-ttl' => 3200})
    end

    tests("#head_container('fogcdncontainertests')").succeeds do
      Fog::CDN[:hp].head_container('fogcdncontainertests')
    end

    tests("#delete_container('fogcdncontainertests')").succeeds do
      Fog::CDN[:hp].delete_container('fogcdncontainertests')
    end

  end

  tests('failure') do

    tests("#post_container('fognoncdncontainer', {'x-ttl' => 3200})").raises(Fog::CDN::HP::NotFound) do
      Fog::CDN[:hp].post_container('fogcdnnoncontainer', {'x-ttl' => 3200})
    end

    tests("#head_container('fognoncdncontainer')").raises(Fog::CDN::HP::NotFound) do
      Fog::CDN[:hp].head_container('fognoncdncontainer')
    end

    tests("#delete_container('fognoncdncontainer')").raises(Fog::CDN::HP::NotFound) do
      Fog::CDN[:hp].delete_container('fognoncdncontainer')
    end

  end

end
