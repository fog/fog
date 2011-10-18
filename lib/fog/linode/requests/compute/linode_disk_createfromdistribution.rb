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
    end
  end
end
