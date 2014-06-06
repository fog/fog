module Fog
  module Rackspace
    class Monitoring
      class Real
        def get_filesystems_info(agent_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "agents/#{agent_id}/host_info/filesystems"
          )
        end
      end

      class Mock
        def get_filesystems_info(agent_id)
          if agent_id == -1
            raise Fog::Rackspace::Monitoring::BadRequest
          end

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "info"  => [
              {
                "dir_name"        => "/",
                "dev_name"        => "/dev/xvda1",
                "sys_type_name"   => "ext4",
                "options"         => "rw,noatime,acl,errors=remount-ro,barrier=0",
                "free"            => Fog::Mock.random_numbers(8).to_i,
                "used"            => Fog::Mock.random_numbers(5).to_i,
                "avail"           => Fog::Mock.random_numbers(7).to_i,
                "total"           => Fog::Mock.random_numbers(9).to_i,
                "files"           => Fog::Mock.random_numbers(6).to_i,
                "free_files"      => Fog::Mock.random_numbers(6).to_i,
              },
              {
                "dir_name"        => "/proc",
                "dev_name"        => "proc",
                "sys_type_name"    => "ext4",
                "options"         => "rw",
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
