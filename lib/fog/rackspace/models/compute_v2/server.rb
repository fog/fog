require 'fog/compute/models/server'

module Fog
  module Compute
    class RackspaceV2
      class Server < Fog::Compute::Server
        # States
        ACTIVE = 'ACTIVE'
        BUILD = 'BUILD'
        DELETED = 'DELETED'
        ERROR = 'ERROR'
        HARD_REBOOT = 'HARD_REBOOT'
        MIGRATING = 'MIGRATING'
        PASSWORD = 'PASSWORD'
        REBOOT = 'REBOOT'
        REBUILD = 'REBUILD'
        RESCUE = 'RESCUE'
        RESIZE = 'RESIZE'
        REVERT_RESIZE = 'REVERT_RESIZE'
        SUSPENDED = 'SUSPENDED'
        UNKNOWN = 'UNKNOWN'
        VERIFY_RESIZE = 'VERIFY_RESIZE'

        identity :id

        attribute :name
        attribute :created
        attribute :updated
        attribute :host_id, :aliases => 'hostId'
        attribute :state, :aliases => 'status'
        attribute :progress
        attribute :user_id
        attribute :tenant_id
        attribute :links
        attribute :metadata
        attribute :personality
        attribute :ipv4_address, :aliases => 'accessIPv4'
        attribute :ipv6_address, :aliases => 'accessIPv6'
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :bandwidth, :aliases => 'rax-bandwidth:bandwidth'
        attribute :addresses
        attribute :flavor_id, :aliases => 'flavor', :squash => 'id'
        attribute :image_id, :aliases => 'image', :squash => 'id'
        
        attr_reader :password

        def save
          if identity
            update
          else
            create
          end
          true
        end

        def create
          requires :name, :image_id, :flavor_id

          options = {}
          options[:disk_config] = disk_config unless disk_config.nil?
          options[:metadata] = metadata unless metadata.nil?
          options[:personality] = personality unless personality.nil?

          data = connection.create_server(name, image_id, flavor_id, 1, 1, options)
          merge_attributes(data.body['server'])
          true
        end

        def update
          requires :identity, :name
          data = connection.update_server(identity, name)
          merge_attributes(data.body['server'])
          true
        end

        def destroy
          requires :identity
          connection.delete_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          @flavor ||= connection.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          @image ||= connection.images.get(image_id)
        end

        def attachments
          @attachments ||= begin
            Fog::Compute::RackspaceV2::Attachments.new({
              :connection => connection,
              :server => self
            })
          end
        end
        
        def private_ip_address
          addresses['private'].select{|a| a["version"] == 4}[0]["addr"]
        end

        def public_ip_address
          ipv4_address
        end

        def ready?
          state == ACTIVE
        end

        def reboot(type = 'SOFT')
          requires :identity
          connection.reboot_server(identity, type)
          self.state = type == 'SOFT' ? REBOOT : HARD_REBOOT
          true
        end

        def resize(flavor_id)
          requires :identity
          connection.resize_server(identity, flavor_id)
          self.state = RESIZE
          true
        end

        def rebuild(image_id)
          requires :identity
          connection.rebuild_server(identity, image_id)
          self.state = REBUILD
          true
        end

        def confirm_resize
          requires :identity
          connection.confirm_resize_server(identity)
          true
        end

        def revert_resize
          requires :identity
          connection.revert_resize_server(identity)
          true
        end

        def change_admin_password(password)
          requires :identity
          connection.change_server_password(identity, password)
          self.state = PASSWORD
          @password = password
          true
        end
        
        def setup(credentials = {})
          requires :public_ip_address, :identity, :public_key, :username
          Fog::SSH.new(public_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
            %{echo "#{Fog::JSON.encode(attributes)}" >> ~/attributes.json},
            %{echo "#{Fog::JSON.encode(metadata)}" >> ~/metadata.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        private

        def adminPass=(new_admin_pass)
          @password = new_admin_pass
        end
      end
    end
  end
end
