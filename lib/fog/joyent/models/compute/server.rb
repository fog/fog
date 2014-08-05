require 'fog/compute/models/server'
module Fog
  module Compute
    class Joyent
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

        def snapshots
          requires :id
          service.snapshots.all(id)
        end

        def update_metadata(data = {})
          requires :id
          service.update_machine_metadata(self.id, data)
          self.reload
          true
        end

        def delete_metadata(keyname)
          raise ArgumentError, "Must provide a key name to delete" if keyname.nil? || keyname.empty?
          requires :id

          service.delete_machine_metadata(self.id, keyname)
          true
        end

        def delete_all_metadata
          requires :id
          service.delete_all_machine_metadata(self.id)
          true
        end

        def list_tags
          requires :id
          service.list_machine_tags(id).body
        end

        def add_tags(tags_hash = {})
          requires :id
          service.add_machine_tags(self.id, tags_hash).body
        end

        def delete_tag(tagname)
          requires :id

          raise ArgumentError, "Must provide a tag name to delete" if tagname.nil? || tagname.empty?
          service.delete_machine_tag(self.id, tagname)
          true
        end

        def delete_all_tags
          requires :id

          service.delete_all_machine_tags(self.id)
          true
        end
      end
    end
  end
end
