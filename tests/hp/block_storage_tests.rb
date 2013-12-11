require 'date'

Shindo.tests('Fog::HP::BlockStorage', ['hp', 'blockstorage']) do
  credentials = {
    :auth_token => 'auth_token',
    :endpoint_url => 'http://127.0.0.1/bpath/',
    :service_catalog => {
      :"Block Storage" => {
      :zone => 'http://127.0.0.1/bpath/'}},
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
  tests('Test good credentials').returns(credentials) do
    conn = Fog::HP::BlockStorage::Real.new(options)
    conn.credentials
  end
  tests('Test expired credentials') do
    credentials[:expires] = (DateTime.now - 1).to_s
    raises(Excon::Errors::Unauthorized) { Fog::HP::BlockStorage::Real.new(options) }
  end
  tests('Test no expires') do
    credentials[:expires] = nil
    raises(Excon::Errors::Unauthorized) { Fog::HP::BlockStorage::Real.new(options) }
  end
  tests('Test no creds') do
    options[:credentials] = nil
    raises(Excon::Errors::Unauthorized) { Fog::HP::BlockStorage::Real.new(options) }
  end
  tests('Test no service') do
    options[:credentials] = credentials
    options[:credentials][:service_catalog] = {
      :"CDN" => {
      :zone => 'http://127.0.0.1/bpath/'}},
    raises(Excon::Errors::Unauthorized) { Fog::HP::BlockStorage::Real.new(options) }
  end
  tests('Test no creds') do
    options[:credentials][:service_catalog] = nil
    raises(Excon::Errors::Unauthorized) { Fog::HP::BlockStorage::Real.new(options) }
  end
end
