module Fog
  module Compute
    class Linode
      class Real

        def linode_disk_list(linode_id, disk_id=nil)
          options = {}
          if disk_id
            options.merge!(:diskId => disk_id)
          end          
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'linode.disk.list', :linodeId => linode_id }.merge!(options)
          )
        end

      end
    end
  end
end
