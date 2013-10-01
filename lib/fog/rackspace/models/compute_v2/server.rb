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

        # @!attribute [r] id
        # @return [String] The server id
        identity :id

        # @!attribute [rw] name
        # @return [String] The server name.
        attribute :name
        
        # @!attribute [r] created        
        # @return [String] The time stamp for the creation date.
        attribute :created
        
        # @!attribute [r] updated
        # @return [String] The time stamp for the last update.
        attribute :updated
        
        # @!attribute [r] host Id
        #   The host Id.
        #   The compute provisioning algorithm has an anti-affinity property that attempts to spread customer VMs across hosts. 
        #   Under certain situations, VMs from the same customer might be placed on the same host. 
        #   hostId represents the host your server runs on and can be used to determine this scenario if it is relevant to your application.
        #   HostId is unique per account and is not globally unique.        
        # @return [String] host id. 
        attribute :host_id, :aliases => 'hostId'

        # @!attribute [r] state
        # @return [String] server status. 
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Servers-d1e2078.html#server_status
        attribute :state, :aliases => 'status'

        # @!attribute [r] state_ext
        # @return [String] server (extended) status. 
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Servers-d1e2078.html#server_status
        attribute :state_ext, :aliases => 'OS-EXT-STS:task_state'
                
        # @!attribute [r] progress
        # @return [Fixnum] The build completion progress, as a percentage. Value is from 0 to 100.
        attribute :progress

        # @!attribute [r] user_id
        # @return [String] The user Id.
        attribute :user_id
        
        # @!attribute [r] tenant_id
        # @return [String] The tenant Id.
        attribute :tenant_id
        
        # @!attribute [r] links
        # @return [Array] Server links.
        attribute :links
        
        # @!attribute [rw] personality
        # @note This attribute is only used for server creation. This field will be nil on subsequent retrievals.
        # @return [Hash] Hash containing data to inject into the file system of the cloud server instance during server creation.
        # @example To inject fog.txt into file system
        #   :personality => [{ :path => '/root/fog.txt',
        #                      :contents => Base64.encode64('Fog was here!')
        #                   }]
        # @see #create
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Personality-d1e2543.html
        attribute :personality
        
        # @!attribute [rw] ipv4_address
        # @return [String] The public IP version 4 access address.
        # @note This field will populate once the server is ready to use. 
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Primary_Addresses-d1e2558.html
        attribute :ipv4_address, :aliases => 'accessIPv4'
        
        # @!attribute [rw] ipv6_address
        # @return [String] The public IP version 6 access address.
        # @note This field will populate once the server is ready to use.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Server_Primary_Addresses-d1e2558.html       
        attribute :ipv6_address, :aliases => 'accessIPv6'
        
        # @!attribute [rw] disk_config
        # @return [String<AUTO, MANUAL>] The disk configuration value.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#diskconfig_attribute
        #        
        # The disk configuration value.
        #   * AUTO -   The server is built with a single partition the size of the target flavor disk. The file system is automatically adjusted to fit the entire partition. 
        #              This keeps things simple and automated. AUTO is valid only for images and servers with a single partition that use the EXT3 file system. 
        #              This is the default setting for applicable Rackspace base images.
        #
        #   * MANUAL - The server is built using whatever partition scheme and file system is in the source image. If the target flavor disk is larger, 
        #              the remaining disk space is left unpartitioned. This enables images to have non-EXT3 file systems, multiple partitions, 
        #              and so on, and enables you to manage the disk configuration.
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'
        
        # @!attribute [r] bandwidth
        # @return [Array] The amount of bandwidth used for the specified audit period.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ch_extensions.html#bandwidth_extension
        attribute :bandwidth, :aliases => 'rax-bandwidth:bandwidth'
        
        # @!attribute [r] address
        # @return [Hash<String, Array[Hash]>] IP addresses allocated for server by network
        # @example  
        #  { 
        #     "public" => [
        #          {"version"=>4, "addr"=>"166.78.105.63"}, 
        #          {"version"=>6, "addr"=>"2001:4801:7817:0072:0fe1:75e8:ff10:61a9"}
        #                 ], 
        #    "private"=> [{"version"=>4, "addr"=>"10.177.18.209"}]
        #  }
        attribute :addresses
        
        # @!attribute [r] flavor_id
        # @return [String] The flavor Id. 
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Flavors-d1e4188.html
        attribute :flavor_id, :aliases => 'flavor', :squash => 'id'
        
        # @!attribute [r] image_id
        # @return [String] The image Id.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Images-d1e4435.html
        attribute :image_id, :aliases => 'image', :squash => 'id'
        # @!attribute [r] password
        # @return [String] Password for system adminstrator account. 
        # @note This value is ONLY populated on server creation.
        attr_reader :password 


        def initialize(attributes={})
          @service = attributes[:service]
          super
        end

        alias :access_ipv4_address :ipv4_address
        alias :access_ipv4_address= :ipv4_address=
        alias :access_ipv6_address :ipv6_address
        alias :access_ipv6_address= :ipv6_address=

        # Server metadata
        # @return [Fog::Compute::RackspaceV2::Metadata] metadata key value pairs.
        def metadata
          @metadata ||= begin
            Fog::Compute::RackspaceV2::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        # Set server metadata
        # @param [Hash] hash contains key value pairs
        def metadata=(hash={})
          metadata.from_hash(hash)
        end

        # Saves the server.
        # Creates server if it is new, otherwise it will update server attributes name, accessIPv4, and accessIPv6.
        # @return [Boolean] true if server has started saving
        def save(options = {})
          if persisted?
            update
          else
            create(options)
          end
          true
        end

        # Creates server
        # * requires attributes: service:, :name, :image_id, and :flavor_id
        # * optional attributes :disk_config, :metadata, :personality
        # @return [Boolean] returns true if server is being created
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note You should use servers.create to create servers instead calling this method directly
        # @see Servers#create
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/CreateServers.html        
        #
        # * State Transitions
        #   * BUILD -> ACTIVE
        #   * BUILD -> ERROR (on error)
        def create(options)
          requires :name, :image_id, :flavor_id
          modified_options = Marshal.load(Marshal.dump(options))

          modified_options[:networks] ||= attributes[:networks]
          modified_options[:disk_config] = disk_config unless disk_config.nil?
          modified_options[:metadata] = metadata.to_hash unless @metadata.nil?
          modified_options[:personality] = personality unless personality.nil?
          modified_options[:keypair] ||= attributes[:keypair]

          if modified_options[:networks]
            modified_options[:networks].map! { |id| { :uuid => id } }
          end
          data = service.create_server(name, image_id, flavor_id, 1, 1, modified_options)
          merge_attributes(data.body['server'])
          true
        end

        # Updates server
        # This will update :name, :accessIPv4, and :accessIPv6 attributes.
        # @note If you edit the server name, the server host name does not change. Also, server names are not guaranteed to be unique.
        # @return true if update has started updating
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/ServerUpdate.html
        #
        # * State Transition
        #   * ACTIVE -> ACTIVE
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

        # Destroy the server
        # @return [Boolean] returns true if server has started deleting
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Server-d1e2883.html
        #
        # * Status Transition:
        #   * ACTIVE -> DELETED
        #   * ERROR -> DELETED
        def destroy
          requires :identity
          service.delete_server(identity)
          true
        end

        # Server flavor
        # @return [Fog::Compute::RackspaceV2::Flavor] server flavor
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def flavor
          requires :flavor_id
          @flavor ||= service.flavors.get(flavor_id)
        end

        # Server image
        # @return [Fog::Compute::RackspaceV2::Image] server image
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        def image
          requires :image_id
          @image ||= service.images.get(image_id)
        end

        # Creates Image from server. Once complete, a new image is available that you can use to rebuild or create servers. 
        # @param name [String] name of image to create
        # @param options [Hash]:
        # @option options [Hash<String, String>] metadata hash of containing metadata key value pairs.
        # @return [Fog::ComputeRackspaceV2::Image] image being created
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Create_Image-d1e4655.html
        #
        # * State Transition:
        #   * SAVING -> ACTIVE
        #   * SAVING  -> ERROR (on error)
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

        # Attached Cloud Block Volumes
        # @return [Fog::Compute::RackspaceV2::Attachments] attached Cloud Block Volumes 
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Volume_Attachments.html
        def attachments
          @attachments ||= begin
            Fog::Compute::RackspaceV2::Attachments.new({
              :service => service,
              :server => self
            })
          end
        end

        # Attaches Cloud Block Volume
        # @param [Fog::Rackspace::BlockStorage::Volume, String] volume object or the volume id of volume to mount
        # @param [String] device name of the device /dev/xvd[a-p]  (optional)
        # @return [Fog::Compute::RackspaceV2::Attachment] resulting attachment object
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Attach_Volume_to_Server.html
        def attach_volume(volume, device=nil)
          requires :identity
          volume_id = volume.is_a?(String) ? volume : volume.id
          attachments.create(:server_id => identity, :volume_id => volume_id, :device => device)
        end

        # Server's private IPv4 address
        # @return [String] private IPv4 address
        def private_ip_address
          addresses['private'].select{|a| a["version"] == 4}[0]["addr"] rescue ''
        end

        # Server's public IPv4 address
        # @return [String] public IPv4 address
        def public_ip_address
          ipv4_address
        end

        # Is server is in ready state
        # @param [String] ready_state By default state is ACTIVE
        # @param [Array,String] error_states By default state is ERROR
        # @return [Boolean] returns true if server is in a ready state
        # @raise [Fog::Compute::RackspaceV2::InvalidServerStateException] if server state is an error state
        def ready?(ready_state = ACTIVE, error_states=[ERROR])
          if error_states
            error_states = Array(error_states)
            raise InvalidServerStateException.new(ready_state, state) if error_states.include?(state)
          end
          state == ready_state
        end

        # Reboot server
        # @param [String<SOFT, HARD>] type 'SOFT' will do a soft reboot. 'HARD' will do a hard reboot.
        # @return [Boolean] returns true if server is being rebooted
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Reboot_Server-d1e3371.html
        #
        # * State transition:
        #   * ACTIVE -> REBOOT  -> ACTIVE (soft reboot)
        #   * ACTIVE -> HARD_REBOOT -> ACTIVE (hard reboot)
        def reboot(type = 'SOFT')
          requires :identity
          service.reboot_server(identity, type)
          self.state = type == 'SOFT' ? REBOOT : HARD_REBOOT
          true
        end


        # Rebuild removes all data on the server and replaces it with the specified image. The id and all IP addresses remain the same.
        # @param [String] image_id image to use for rebuild
        # @return [Boolean] returns true if rebuild is in process
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Rebuild_Server-d1e3538.html
        #
        # * Status Transition:
        #   * ACTIVE -> REBUILD -> ACTIVE
        #   * ACTIVE -> REBUILD -> ERROR (on error)
        def rebuild(image_id, options={})
          requires :identity
          service.rebuild_server(identity, image_id, options)
          self.state = REBUILD
          true
        end

        # Resize existing server to a different flavor, in essence, scaling the server up or down. The original server is saved for a period of time to allow rollback if there is a problem. All resizes should be tested and explicitly confirmed, at which time the original server is removed. All resizes are automatically confirmed after 24 hours if they are not confirmed or reverted.     
        # @param [String] flavor_id to resize
        # @return [Boolean] returns true if resize is in process
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note All resizes are automatically confirmed after 24 hours if you do not explicitly confirm or revert the resize.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Resize_Server-d1e3707.html
        # @see #confirm_resize
        # @see #revert_resize
        #
        # * Status Transition:
        #   * ACTIVE -> QUEUE_RESIZE -> PREP_RESIZE -> VERIFY_RESIZE
        #   * ACTIVE -> QUEUE_RESIZE -> ACTIVE (on error)
        def resize(flavor_id)
          requires :identity
          service.resize_server(identity, flavor_id)
          self.state = RESIZE
          true
        end

        # Confirms server resize operation
        # @return [Boolean] returns true if resize has been confirmed
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note All resizes are automatically confirmed after 24 hours if you do not explicitly confirm or revert the resize.        
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Confirm_Resized_Server-d1e3868.html
        # @see #resize
        #
        # * Status Transition:
        #   * VERIFY_RESIZE -> ACTIVE
            #   * VERIFY_RESIZE -> ERROR (on error)å
        def confirm_resize
          requires :identity
          service.confirm_resize_server(identity)
          true
        end

        # Reverts server resize operation
        # @return [Boolean] returns true if resize is being reverted
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note All resizes are automatically confirmed after 24 hours if you do not explicitly confirm or revert the resize.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Revert_Resized_Server-d1e4024.html
        # @see #resize
        #
        # * Status Transition:
        #   * VERIFY_RESIZE -> ACTIVE
        #   * VERIFY_RESIZE -> ERROR (on error)
        def revert_resize
          requires :identity
          service.revert_resize_server(identity)
          true
        end

        # Place existing server into rescue mode, allowing for offline editing of configuration. The original server's disk is attached to a new instance of the same base image for a period of time to facilitate working within rescue mode.  The original server will be automatically restored after 90 minutes.
        # @return [Boolean] returns true if call to put server in rescue mode reports success
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        # @note Rescue mode is only guaranteed to be active for 90 minutes.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/rescue_mode.html
        # @see #unrescue
        #
        # * Status Transition:
        #   * ACTIVE -> PREP_RESCUE -> RESCUE
        def rescue
          requires :identity
          data = service.rescue_server(identity)
          merge_attributes(data.body)
          true
        end

        # Remove existing server from rescue mode.
        # @return [Boolean] returns true if call to remove server from rescue mode reports success
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        # @note Rescue mode is only guaranteed to be active for 90 minutes.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/exit_rescue_mode.html
        # @see #rescue
        #
        # * Status Transition:
        #   * PREP_UNRESCUE -> ACTIVE
        def unrescue
          requires :identity
          service.unrescue_server(identity)
          self.state = ACTIVE
          true
        end

        # Change admin password
        # @param [String] password The administrator password.
        # @return [Boolean] returns true if operation was scheduled
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note Though Rackspace does not enforce complexity requirements for the password, the operating system might. If the password is not complex enough, the server might enter an ERROR state.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Change_Password-d1e3234.html
        #
        # * Status Transition:	
        #   * ACTIVE -> PASSWORD -> ACTIVE
        #   * ACTIVE -> PASSWORD -> ERROR (on error)        
        def change_admin_password(password)
          requires :identity
          service.change_server_password(identity, password)
          self.state = PASSWORD
          @password = password
          true
        end

        # Setup server for SSH access
        # @see Servers#bootstrap
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
