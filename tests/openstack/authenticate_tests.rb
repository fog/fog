Shindo.tests('OpenStack | authenticate', ['openstack']) do
  begin
    @old_mock_value = Excon.defaults[:mock]
    Excon.defaults[:mock] = true
    Excon.stubs.clear

    expires      = Time.now.utc + 600
    token        = Fog::Mock.random_numbers(8).to_s
    tenant_token = Fog::Mock.random_numbers(8).to_s

    body = {
      "access" => {
        "token" => {
          "expires" => expires.iso8601,
          "id"      => token,
          "tenant"  => {
            "enabled"     => true,
            "description" => nil,
            "name"        => "admin",
            "id"          => tenant_token,
          }
        },
        "serviceCatalog" => [{
          "endpoints" => [{
            "adminURL" =>
              "http://example/v2/#{tenant_token}",
              "region" => "RegionOne",
            "internalURL" =>
              "http://example/v2/#{tenant_token}",
            "id" => Fog::Mock.random_numbers(8).to_s,
            "publicURL" =>
             "http://example/v2/#{tenant_token}"
          }],
          "endpoints_links" => [],
          "type" => "compute",
          "name" => "nova"
        }],
        "user" => {
          "username" => "admin",
          "roles_links" => [],
          "id" => Fog::Mock.random_numbers(8).to_s,
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
            Fog::Mock.random_numbers(8).to_s,]}}}

    tests("authenticate_v2") do
      Excon.stub({ :method => 'POST', :path => "/v2.0/tokens" },
                 { :status => 200, :body => Fog::JSON.encode(body) })

      expected = {
        :user                     => body['access']['user'],
        :tenant                   => body['access']['token']['tenant'],
        :identity_public_endpoint => nil,
        :server_management_url    =>
          body['access']['serviceCatalog'].
            first['endpoints'].first['publicURL'],
        :token                    => token,
        :expires                  => expires.iso8601,
        :current_user_id          => body['access']['user']['id'],
        :unscoped_token           => token,
      }

      returns(expected) do
        Fog::OpenStack.authenticate_v2(
          :openstack_auth_uri     => URI('http://example/v2.0/tokens'),
          :openstack_tenant       => 'admin',
          :openstack_service_name => 'compute')
      end
    end
  ensure
    Excon.stubs.clear
    Excon.defaults[:mock] = @old_mock_value
  end
end

