Shindo.tests('Fog::Compute::HP', ['hp', 'compute']) do
  credentials = {
    :auth_token => 'auth_token',
    :endpoint_url => 'http://127.0.0.1/computepath/',
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
  tests('Test cached Compute credentials').returns(credentials) do
    conn = Fog::Compute::HP::Real.new(options)
    conn.credentials
  end
end
