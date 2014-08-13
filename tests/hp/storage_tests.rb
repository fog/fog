unless ENV["FOG_MOCK"] == "true"
  Shindo.tests('Fog::Storage::HP', ['hp', 'storage']) do
    credentials = {
      :auth_token       => 'auth_token',
      :endpoint_url     => 'http://127.0.0.1/path/',
      :cdn_endpoint_url => 'http://127.0.0.1/cdnpath/',
      :service_catalog  => {
        :"Object Storage" => {
          :zone => 'http://127.0.0.1/path/'},
        :"CDN"            => {
          :zone => 'http://127.0.0.1/cdnpath/'}},
      :expires          => (DateTime.now + 1).to_s
    }
    options     = {
      :hp_access_key => 'key',
      :hp_secret_key => 'secret',
      :hp_tenant_id  => 'tenant',
      :hp_avl_zone   => 'zone',
      :hp_auth_uri   => 'https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens',
      :credentials   => credentials
    }
    tests('Test cached Storage credentials').returns(credentials) do

      conn = Fog::Storage::HP::Real.new(options)
      conn.credentials
    end
  end
end
