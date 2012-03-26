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
        attribute :ips
        attribute :memory
        attribute :ips
        attribute :disk
        attribute :metadata

        attribute :created, :type => :time
        attribute :updated, :type => :time

        def ready?
          self.state == 'running'
        end

        def stopped?
          requires :id
          self.state == 'stopped'
        end

        def destroy
          requires :id
          self.connection.delete_machine(id)
          true
        end

        def start
          requires :id
          self.connection.start_machine(id)
          self.wait_for { ready? }
          true
        end

        def stop
          requires :id
          self.connection.stop_machine(id)
          self.wait_for { stopped? }
          true
        end

        def resize(flavor)
          requires :id
          self.connection.resize(id, flavor)
          true
        end

        def reboot
          requires :id
          self.connection.reboot_machine(id)
          true
        end

        def snapshots
          requires :id
          self.connection.snapshots.all(id)
        end

        def update_metadata(data = {})
          requires :id
          self.connection.update_machine_metadata(self.id, data)
          self.reload
          true
        end

        def delete_metadata(keyname)
          raise ArgumentError, "Must provide a key name to delete" if keyname.nil? || keyname.empty?
          requires :id

          self.connection.delete_machine_metadata(self.id, keyname)
          true
        end

        def delete_all_metadata
          requires :id
          self.connection.delete_all_machine_metadata(self.id)
          true
        end

        def tags
          requires :id
          self.connection.list_machine_tags(id).body
        end

        def add_tags(tags_hash = {})
          requires :id
          self.connection.add_machine_tags(self.id, tags_hash).body
        end

        def delete_tag(tagname)
          requires :id

          raise ArgumentError, "Must provide a tag name to delete" if tagname.nil? || tagname.empty?
          self.connection.delete_machine_tag(self.id, tagname)
          true
        end

        def delete_all_tags
          requires :id

          self.connection.delete_all_machine_tags(self.id)
          true
        end

      end
    end
  end
end
