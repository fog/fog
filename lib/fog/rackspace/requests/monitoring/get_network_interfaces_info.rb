module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_network_interfaces_info(agent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents/#{agent_id}/host_info/network_interfaces"
          )
        end
      end

      class Mock
        def get_network_interfaces_info(agent_id)
          if agent_id == -1
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "info"  => [
              {
                "name"        => "lo",
                "type"        => "Local Loopback",
                "address"     => Fog::Mock.random_ip({:version => :v4}),
                "netmask"     => "255.0.0.0",
                "address6"    => "::1",
                "broadcast"   => "0.0.0.0.0",
                "hwaddr"      => "00:00:00:00:00:00",
                "mtu"         => Fog::Mock.random_numbers(4).to_i,
                "rx_packets"  => Fog::Mock.random_numbers(3).to_i,
                "rx_bytes"    => Fog::Mock.random_numbers(4).to_i,
                "tx_packets"  => Fog::Mock.random_numbers(3).to_i,
                "tx_bytes"    => Fog::Mock.random_numbers(4).to_i,
                "flags"       => Fog::Mock.random_numbers(2).to_i,
              },
              {
                "name"        => "eth0",
                "type"        => "Ethernet",
                "address"     => Fog::Mock.random_ip({:version => :v4}),
                "netmask"     => "255.255.255.0",
                "address6"    => Fog::Mock.random_ip({:version => :v6}),
                "broadcast"   => Fog::Mock.random_ip({:version => :v4}),
                "hwaddr"      => "A1:B2:C3:D4:E5:F6",
                "mtu"         => "1500",
                "rx_packets"  => Fog::Mock.random_numbers(7).to_i,
                "rx_bytes"    => Fog::Mock.random_numbers(9).to_i,
                "tx_packets"  => Fog::Mock.random_numbers(7).to_i,
                "tx_bytes"    => Fog::Mock.random_numbers(9).to_i,
                "flags"       => Fog::Mock.random_numbers(4).to_i,
              },
              {
                "name"        => "eth1",
                "type"        => "Ethernet",
                "address"     => Fog::Mock.random_ip({:version => :v4}),
                "netmask"     => "255.255.128.0",
                "address6"    => Fog::Mock.random_ip({:version => :v6}),
                "broadcast"   => Fog::Mock.random_ip({:version => :v4}),
                "hwaddr"      => "A2:B3:C4:D5:E6:F7",
                "mtu"         => "1500",
                "rx_packets"  => Fog::Mock.random_numbers(7).to_i,
                "rx_bytes"    => Fog::Mock.random_numbers(9).to_i,
                "tx_packets"  => Fog::Mock.random_numbers(7).to_i,
                "tx_bytes"    => Fog::Mock.random_numbers(9).to_i,
                "flags"       => Fog::Mock.random_numbers(4).to_i,
              }
            ]
          }
          response.headers = {
            "Date"                  => Time.now.utc.to_s,
            "Content-Type"          => "application/json; charset=UTF-8",
            "X-RateLimit-Limit"     => "50000",
            "X-RateLimit-Remaining" => "49627",
            "X-RateLimit-Window"    => "24 hours",
            "X-RateLimit-Type"      => "global",
            "X-Response-Id"         => "j23jlk234jl2j34j",
            "X-LB"                  => "dfw1-maas-prod-api0",
            "Vary"                  => "Accept-Encoding",
            "Transfer-Encoding"     => "chunked"
          }
          response.remote_ip = Fog::Mock.random_ip({:version => :v4})
          response
        end
      end
    end
  end
end
