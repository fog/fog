Shindo.tests('Fog::CDN::HP', ['hp', 'cdn']) do
  credentials = {
    :auth_token => 'auth_token',
    :endpoint_url => 'http://127.0.0.1/cdnpath/',
    :cdn_endpoint_url => 'http://127.0.0.1/cdnpath/',
    :service_catalog => {
      :"CDN" => {
      :zone => 'http://127.0.0.1/cdnpath/'}},
    :expires => (DateTime.now + 1).to_s
  }
  options = {
    :hp_access_key => 'key',
    :hp_secret_key => 'secret',
    :hp_tenant_id => 'tenant',
    :hp_avl_zone => 'zone',
    :hp_auth_uri => 'https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/tokens',
    :credentials => credentials
  }
  tests('Test cached CDN credentials').returns(credentials) do
    conn = Fog::CDN::HP::Real.new(options)
    conn.credentials
  end
end
