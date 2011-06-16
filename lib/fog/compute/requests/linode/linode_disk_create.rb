module Fog
  module Compute
    class Linode
      class Real

        def linode_disk_create(linode_id, name, type, size)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action => 'linode.disk.create',
              :linodeId => linode_id,
              :label => name,
              :type => type,
              :size => size
            }
          )
        end

      end
    end
  end
end
