Shindo.tests('OpenStack | versions', ['openstack']) do
  begin
    @old_mock_value = Excon.defaults[:mock]
    Excon.defaults[:mock] = true
    Excon.stubs.clear

    body = {
        "versions" => [
            { "status" => "CURRENT", "id" => "v2.0", "links" => [ {
                                                                      "href" => "http://example:9292/v2/",
                                                                      "rel" => "self" }
                                                                ]
            },
            { "status" => "CURRENT", "id" => "v1.1", "links" => [ {
                                                                      "href" => "http://exampple:9292/v1/",
                                                                      "rel" => "self"
                                                                  }
                                                                ]
            },
            { "status" => "SUPPORTED", "id"=>"v1.0", "links" => [ {
                                                                      "href" => "http://example:9292/v1/",
                                                                      "rel" => "self"
                                                                  }
                                                                ]
            }
        ]
    }

    tests("supported") do
      Excon.stub({ :method => 'GET' },
                 { :status => 300, :body => Fog::JSON.encode(body) })

      returns("v1.1") do
        Fog::OpenStack.get_supported_version(/v1(\.(0|1))*/,
                                             URI('http://example/'),
                                             "authtoken")
      end
    end

    tests("unsupported") do
      Excon.stub({ :method => 'GET' },
                 { :status => 300, :body => Fog::JSON.encode(body) })

      raises(Fog::OpenStack::Errors::ServiceUnavailable) do
        Fog::OpenStack.get_supported_version(/v3(\.(0|1))*/,
                                             URI('http://example/'),
                                             "authtoken")
      end
    end

  ensure
    Excon.stubs.clear
    Excon.defaults[:mock] = @old_mock_value
  end
end
