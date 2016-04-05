require 'fog/compute/models/server'
module Fog
  module Compute
    class DimensionData
      class Server < Fog::Compute::Server
        identity :id

        attribute :name
        attribute :state
        attribute :type
        attribute :dataset
        attribute :compute_node
        attribute :networks
        attribute :ips
        attribute :memory
        attribute :disk
        attribute :metadata
        attribute :tags
        attribute :package
        attribute :image
        attribute :primary_ip, :aliases => 'primaryIp'

        attribute :created, :type => :time
        attribute :updated, :type => :time

        def public_ip_address
          ips.empty? ? nil : ips.first
        end

        def ready?
          self.state == 'running'
        end

        def stopped?
          requires :id
          self.state == 'stopped'
        end

        def destroy
          requires :id
          service.delete_machine(id)
          true
        end

        def start
          requires :id
          service.start_machine(id)
          self.wait_for { ready? }
          true
        end

        def stop
          requires :id
          service.stop_machine(id)
          self.wait_for { stopped? }
          true
        end

        def resize(flavor)
          requires :id
          service.resize_machine(id, flavor.name)
          true
        end

        def reboot
          requires :id
          service.reboot_machine(id)
          true
        end
      end
    end
  end
end
