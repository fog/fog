Shindo.tests('Fog::Compute[:xenserver]', ['xenserver']) do

  tests("Login") do
    raises(Fog::XenServer::InvalidLogin, 'raises error when invalid password') do
      conn = Fog::Compute.new({
        :provider => 'XenServer',
        :xenserver_url => 'xenserver-test',
        :xenserver_username => 'root',
        :xenserver_password => 'asdfsadf'

      })
    end
    raises(Fog::XenServer::InvalidLogin, 'raises error when invalid user') do
      conn = Fog::Compute.new({
        :provider => 'XenServer',
        :xenserver_url => 'xenserver-test',
        :xenserver_username => 'rootffff',
        :xenserver_password => 'changeme'

      })
    end
    raises(SocketError, 'raises error when invalid host') do
      conn = Fog::Compute.new({
        :provider => 'XenServer',
        :xenserver_url => 'xenserver-testlakjsdflkj',
        :xenserver_username => 'root',
        :xenserver_password => 'changeme'

      })
    end
  end

end
