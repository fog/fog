Shindo.tests('Fog CurrentMachine', 'core') do

  pending unless Fog.mock?

  old_excon_defaults_mock = Excon.defaults[:mock]
  Excon.defaults[:mock] = true

  tests('ip_address') do

    tests('should be thread safe') do
      Excon.stub({:method => :get, :path => '/'}, {:body => ''})

      (1..10).map {
        Thread.new { Fog::CurrentMachine.ip_address }
      }.each{ |t| t.join }
    end

    Fog::CurrentMachine.ip_address = nil
    Excon.stubs.clear

    tests('should remove trailing endline characters') do
      Excon.stub({:method => :get,  :path => '/'}, {:body => "192.168.0.1\n"})
      Fog::CurrentMachine.ip_address == '192.168.0.1'
    end

  end

  Fog::CurrentMachine.ip_address = nil
  Excon.stubs.clear
  Excon.defaults[:mock] = old_excon_defaults_mock

end
