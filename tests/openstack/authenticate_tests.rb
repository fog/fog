Shindo.tests('OpenStack | authenticate', ['openstack']) do
  begin
    @old_mock_value = Excon.defaults[:mock]
    Excon.defaults[:mock] = true
    Excon.stubs.clear

    expires         = Time.now.utc + 600
    token           = Fog::Mock.random_numbers(8).to_s
    tenant_token    = Fog::Mock.random_numbers(8).to_s
    unscoped_token  = Fog::Mock.random_numbers(8).to_s

    body = {
      "access" => {
        "token" => {
          "expires" => expires.iso8601,
          "id"      => token,
          "tenant"  => {
            "enabled"     => true,
            "description" => nil,
            "name"        => "admin",
            "id"          => tenant_token
          }
        },
        "serviceCatalog" => [
          { "endpoints" => [
              { "adminURL"    => "http://example:8774/v2/#{tenant_token}",
                "region"      => "RegionOne",
                "internalURL" => "http://example:8774/v2/#{tenant_token}",
                "id"          => Fog::Mock.random_numbers(8).to_s,
                "publicURL"   => "http://example:8774/v2/#{tenant_token}"
              }
            ],
            "endpoints_links" => [],
            "type"            => "compute",
            "name"            => "nova"
          },
          { "endpoints" => [
              { "adminURL"    => "http://example:9292",
                "region"      => "RegionOne",
                "internalURL" => "http://example:9292",
                "id"          => Fog::Mock.random_numbers(8).to_s,
                "publicURL"   => "http://example:9292"
              }
            ],
            "endpoints_links" => [],
            "type"            => "image",
            "name"            => "glance"
          }
        ],
        "user" => {
          "username"    => "admin",
          "roles_links" => [],
          "id"          => Fog::Mock.random_numbers(8).to_s,
          "roles" => [
            { "name" => "admin" },
            { "name" => "KeystoneAdmin" },
            { "name" => "KeystoneServiceAdmin" }
          ],
          "name" => "admin"
        },
        "metadata" => {
          "is_admin" => 0,
          "roles" => [
            Fog::Mock.random_numbers(8).to_s,
            Fog::Mock.random_numbers(8).to_s,
            Fog::Mock.random_numbers(8).to_s
          ]
        }
      }
    }

    body_tenants = {
      "tenants_links" => [],
      "tenants" => [
        { "description" => nil,
          "enabled"     => true,
          "id"          => "097fb34153e6452f8ef638d19e7f4a03",
          "name"        => "admin" },
        { "description" => nil,
          "enabled"     => true,
          "id"          => "651cc4b3000245e88770ebe88b9d33db",
          "name"        => "demo" }
      ]
    }

    expected_credentials = {
      :user                     => body['access']['user'],
      :tenant                   => body['access']['token']['tenant'],
      :identity_public_endpoint => nil,
      :server_management_url    =>
        body['access']['serviceCatalog'].
          first['endpoints'].first['publicURL'],
      :token                    => token,
      :expires                  => expires.iso8601,
      :current_user_id          => body['access']['user']['id']
    }

    after do
      Excon.stubs.clear
    end

    tests("v2") do
      tests('with tenant given') do
        Excon.stub(
          { :method => 'POST',
            :path => "/v2.0/tokens",
            :body => Fog::JSON.encode({
              :auth => {
                :tenantName => 'admin',
                :passwordCredentials => {
                  :username => 'admin',
                  :password => 'password'
                }
              }
            })
          },
          { :status => 200, :body => Fog::JSON.encode(body) }
        )

        returns(expected_credentials, 'returns expected credentials') do
          Fog::OpenStack.authenticate_v2(
            :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
            :openstack_username     => 'admin',
            :openstack_api_key      => 'password',
            :openstack_tenant       => 'admin',
            :openstack_service_type => %w[compute])
        end
      end

      tests('without tenant given') do
        body_no_service = deep_dup(body)
        body_no_service['access']['serviceCatalog'] = []
        body_no_service['access']['token']['id'] = unscoped_token

        Excon.stub(
          { :method => 'POST',
            :path => "/v2.0/tokens",
            :body => Fog::JSON.encode({
              :auth => {
                :tenantName => '',
                :passwordCredentials => {
                  :username => 'admin',
                  :password => 'password'
                }
              }
            })
          },
          { :status => 200, :body => Fog::JSON.encode(body_no_service) }
        )
        Excon.stub(
          { :method => 'GET',
            :path => "/v2.0/tenants",
            :headers => { 'Content-Type' => 'application/json',
                          'Accept' => 'application/json',
                          'X-Auth-Token' => unscoped_token }
          },
          { :status => 200, :body => Fog::JSON.encode(body_tenants) }
        )
        Excon.stub(
          { :method => 'POST',
            :path => "/v2.0/tokens",
            :body => Fog::JSON.encode({
              :auth => {
                :tenantName => 'admin',
                :token => { :id => unscoped_token }
              }
            })
          },
          { :status => 200, :body => Fog::JSON.encode(body) }
        )

        returns(expected_credentials, 'returns expected credentials') do
          Fog::OpenStack.authenticate_v2(
            :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
            :openstack_username     => 'admin',
            :openstack_api_key      => 'password',
            :openstack_service_type => %w[compute])
        end
      end
    end

    tests("v2 default tokens path") do
      tests('with no path given') do
        Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                  { :status => 200, :body => Fog::JSON.encode(body) })

        returns(expected_credentials, 'returns expected credentials') do
          Fog::OpenStack.authenticate_v2(
            :openstack_auth_uri     => URI('http://example'),
            :openstack_tenant       => 'admin',
            :openstack_service_type => %w[compute])
        end
      end

      tests('with / path given') do
        Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                  { :status => 200, :body => Fog::JSON.encode(body) })

        returns(expected_credentials, 'returns expected credentials') do
          Fog::OpenStack.authenticate_v2(
            :openstack_auth_uri     => URI('http://example/'),
            :openstack_tenant       => 'admin',
            :openstack_service_type => %w[compute])
        end
      end
    end

    tests("v2 missing service") do
      tests('without region given') do
        Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                  { :status => 200, :body => Fog::JSON.encode(body) })

        err_msg = "Could not find service(s) 'network' in 'compute, image'."
        returns(err_msg, 'raises expected error') do
          begin
            Fog::OpenStack.authenticate_v2(
              :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
              :openstack_tenant       => 'admin',
              :openstack_service_type => %w[network])
          rescue Fog::Errors::NotFound => err
            err.message
          end
        end
      end

      tests('with region given') do
        Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                  { :status => 200, :body => Fog::JSON.encode(body) })

        err_msg = "Could not find service(s) 'network' in 'compute, image'."
        returns(err_msg, 'raises expected error') do
          begin
            Fog::OpenStack.authenticate_v2(
              :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
              :openstack_tenant       => 'admin',
              :openstack_region       => 'RegionOne',
              :openstack_service_type => %w[network])
          rescue Fog::Errors::NotFound => err
            err.message
          end
        end
      end
    end

    tests("v2 auth with two compute services") do
      body_two_compute = deep_dup(body)
      body_two_compute["access"]["serviceCatalog"] << {
        "endpoints" => [
          { "adminURL"    => "http://example2:8774/v2/#{tenant_token}",
            "region"      => "RegionOne",
            "internalURL" => "http://example2:8774/v2/#{tenant_token}",
            "id"          => Fog::Mock.random_numbers(8).to_s,
            "publicURL"   => "http://example2:8774/v2/#{tenant_token}"
          }
        ],
        "endpoints_links" => [],
        "type"            => "compute",
        "name"            => "nova2"
      }

      Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                 { :status => 200, :body => Fog::JSON.encode(body_two_compute) })

      tests('finds service by service_type and service_name').succeeds do
        resp = Fog::OpenStack.authenticate_v2(
          :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
          :openstack_tenant       => 'admin',
          :openstack_service_type => %w[compute],
          :openstack_service_name => 'nova2')
        resp[:server_management_url] == "http://example2:8774/v2/#{tenant_token}"
      end
    end

    tests("legacy v1 auth") do
      headers = {
        "X-Storage-Url"   => "https://swift.myhost.com/v1/AUTH_tenant",
        "X-Auth-Token"    => "AUTH_yui193bdc00c1c46c5858788yuio0e1e2p",
        "X-Trans-Id"      => "iu99nm9999f9b999c9b999dad9cd999e99",
        "Content-Length"  => "0",
        "Date"            => "Wed, 07 Aug 2013 11:11:11 GMT"
      }

      Excon.stub({:method => 'GET', :path => "/auth/v1.0"},
                 {:status => 200, :body => "", :headers => headers})

      returns("https://swift.myhost.com/v1/AUTH_tenant") do
        Fog::OpenStack.authenticate_v1(
          :openstack_auth_uri     => URI('https://swift.myhost.com/auth/v1.0'),
          :openstack_username     => 'tenant:dev',
          :openstack_api_key      => 'secret_key',
          :openstack_service_type => %w[storage])[:server_management_url]
      end

    end

  ensure
    Excon.defaults[:mock] = @old_mock_value
  end
end

