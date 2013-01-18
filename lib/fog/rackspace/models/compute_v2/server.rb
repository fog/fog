require 'fog/compute/models/server'
require 'fog/rackspace/models/compute_v2/metadata'

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
        attribute :personality
        attribute :ipv4_address, :aliases => 'accessIPv4'
        attribute :ipv6_address, :aliases => 'accessIPv6'
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :bandwidth, :aliases => 'rax-bandwidth:bandwidth'
        attribute :addresses
        attribute :flavor_id, :aliases => 'flavor', :squash => 'id'
        attribute :image_id, :aliases => 'image', :squash => 'id'
        
        ignore_attributes :metadata
        
        attr_reader :password 
        
        def initialize(attributes={})
          @service = attributes[:service]
          super
        end
        
        alias :access_ipv4_address :ipv4_address
        alias :access_ipv4_address= :ipv4_address=
        alias :access_ipv6_address :ipv6_address
        alias :access_ipv6_address= :ipv6_address=
        
        def metadata
          raise "Please save server before accessing metadata" unless identity
          @metadata ||= begin
            Fog::Compute::RackspaceV2::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end
        
        def metadata=(hash={})
          raise "Please save server before accessing metadata" unless identity
          metadata.from_hash(hash)
        end

        def save
          if persisted?
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
          options[:metadata] = metadata unless @metadata.nil?
          options[:personality] = personality unless personality.nil?

          data = service.create_server(name, image_id, flavor_id, 1, 1, options)
          merge_attributes(data.body['server'])
          true
        end

        def update
          requires :identity
          options = {
            'name' => name,
            'accessIPv4' => ipv4_address,
            'accessIPv6' => ipv6_address
          }
          
          data = service.update_server(identity, options)
          merge_attributes(data.body['server'])
          true
        end

        def destroy
          requires :identity
          service.delete_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          @flavor ||= service.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          @image ||= service.images.get(image_id)
        end

        def create_image(name, options = {})
          requires :identity
          response = service.create_image(identity, name, options)
          begin 
            image_id = response.headers["Location"].match(/\/([^\/]+$)/)[1]
            Fog::Compute::RackspaceV2::Image.new(:collection => service.images, :service => service, :id => image_id)
          rescue
            nil
          end
        end

        def attachments
          @attachments ||= begin
            Fog::Compute::RackspaceV2::Attachments.new({
              :service => service,
              :server => self
            })
          end
        end
        
        def attach_volume(volume, device=nil)
          requires :identity
          volume_id = volume.is_a?(String) ? volume : volume.id
          attachments.create(:server_id => identity, :volume_id => volume_id, :device => device)
        end        

        def private_ip_address
          addresses['private'].select{|a| a["version"] == 4}[0]["addr"]
        end

        def public_ip_address
          ipv4_address
        end

        def ready?(ready_state = ACTIVE, error_states=[ERROR])
          if error_states
            error_states = Array(error_states)
            raise "Server should have transitioned to '#{ready_state}' not '#{state}'" if error_states.include?(state)
          end
          state == ready_state
        end

        def reboot(type = 'SOFT')
          requires :identity
          service.reboot_server(identity, type)
          self.state = type == 'SOFT' ? REBOOT : HARD_REBOOT
          true
        end

        def resize(flavor_id)
          requires :identity
          service.resize_server(identity, flavor_id)
          self.state = RESIZE
          true
        end

        def rebuild(image_id, options={})
          requires :identity
          service.rebuild_server(identity, image_id, options)
          self.state = REBUILD
          true
        end

        def confirm_resize
          requires :identity
          service.confirm_resize_server(identity)
          true
        end

        def revert_resize
          requires :identity
          service.revert_resize_server(identity)
          true
        end

        def change_admin_password(password)
          requires :identity
          service.change_server_password(identity, password)
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
