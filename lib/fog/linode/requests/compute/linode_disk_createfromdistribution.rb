module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_createfromdistribution(linode_id, distro_id, name, size, password)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.createfromdistribution',
              :linodeId => linode_id,
              :distributionId => distro_id,
              :label => name,
              :size => size,
              :rootPass => password
            }
          )
        end
      end

      class Mock
        def linode_disk_createfromdistribution(linode_id, distro_id, name, size, password)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.createFromDistribution",
            "DATA"       => { "JobID" => rand(1000..9999),
                              "DiskID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
