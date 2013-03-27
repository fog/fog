require 'date'

Shindo.tests('Fog::HP::BlockStorage', ['hp']) do
  credentials = {
    :auth_token => 'auth_token',
    :endpoint_url => 'http://127.0.0.1:0/path/',
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
  tests('Test good credentials').returns(credentials) do
    conn = Fog::HP::BlockStorage::Real.new(options)
    conn.credentials
  end
  tests('Test expired credentials') do
    credentials[:expires] = (DateTime.now - 1).to_s
    raises(Excon::Errors::SocketError) { Fog::HP::BlockStorage::Real.new(options) }
  end
  tests('Test no expires') do
    credentials[:expires] = nil
    raises(Excon::Errors::SocketError) { Fog::HP::BlockStorage::Real.new(options) }
  end
end
