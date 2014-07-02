module Fog
  module Compute
    class Tutum
      class Real
        def container_logs(uuid)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "container/#{uuid}/logs/"
          )
        end
      end

      class Mock
        def container_logs(uuid)
          {
            "logs" => "2014-03-24 23:58:08,973 CRIT Supervisor running as root (no user in config file)\n2014-03-24 23:58:08,973 WARN Included extra file \"/etc/supervisor/conf.d/supervisord-apache2.conf\" during parsing"
          }
        end
      end
    end
  end
end
