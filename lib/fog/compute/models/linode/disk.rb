require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Disk < Fog::Model
        identity :id
        attribute :name
        attribute :type
        attribute :server_id

        def delete
          connection.linode_disk_delete server_id, id
        end
      end
    end
  end
end
