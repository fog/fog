require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Server < Fog::Model
        identity :id, :aliases => 'ID'
        attribute :name, :aliases => 'Name'
        attribute :server_plan, :aliases => 'ServerPlan'
        attribute :instance, :aliases => 'Instance'
        attribute :disks, :aliases => 'Disks'
        attribute :interfaces, :aliases => 'Interfaces'

        def save
          requires :name, :server_plan
          data = service.create_server(@attributes[:name], @attributes[:server_plan]).body["Server"]
          merge_attributes(data)
          true
        end

        def boot
          requires :id
          service.boot_server(@attributes[:id])
        end

        def stop(force = false)
          requires :id
          service.stop_server(@attributes[:id], force)
        end

        def delete(disks = [])
          requires :id
          service.delete_server(@attributes[:id], disks)
          true
        end
        alias_method :destroy, :delete
      end
    end
  end
end
