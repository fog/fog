Shindo.tests('Fog::CDN::HP', ['hp']) do
  credentials = {
    :auth_token => 'auth_token',
    :endpoint_url => 'http://127.0.0.1/cdnpath/',
    :expires => (DateTime.now + 1).to_s
  }
  options = {
    :hp_access_key => 'hp_account_id',
    :hp_secret_key => 'hp_secret_key',
    :hp_tenant_id => 'hp_tenant_id',
    :hp_avl_zone => 'hp_avl_zone',
    :hp_auth_uri => 'hp_auth_uri',
    :credentials => credentials
  }
  tests('Test cached CDN credentials').returns(credentials) do
    conn = Fog::CDN::HP::Real.new(options)
    conn.credentials
  end
end
