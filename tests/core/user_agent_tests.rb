Shindo.tests('Fog::Connection', 'core') do
  tests('user_agent').returns("fog/#{Fog::VERSION}") do
    conn = Fog::Connection.new("http://www.testserviceurl.com", false, {})
    conn.instance_variable_get(:@excon).data[:headers]['User-Agent']
  end
end
