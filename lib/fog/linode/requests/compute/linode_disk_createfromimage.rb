module Fog
  module Compute
    class Linode
      class Real
        def linode_disk_createfromimage(linode_id, image_id, size, password, sshkey)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.createfromimage',
              :linodeId => linode_id,
              :distributionId => distro_id,
              :size => size,
              :rootPass => password,
              :rootSSHKey => sshkey
            }
          )
        end
      end

      class Mock
        def linode_disk_createfromimage(linode_id, distro_id, name, size, password)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ERRORARRAY" => [],
            "ACTION"     => "linode.disk.createfromimage",
            "DATA"       => { "JobID" => rand(1000..9999),
                              "DiskID" => rand(10000..99999) }
          }
          response
        end
      end
    end
  end
end
