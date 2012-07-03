require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class Instance < Fog::Model
        # States
        ACTIVE = 'ACTIVE'
        BUILD = 'BUILD'
        BLOCKED = 'BLOCKED'
        REBOOT = 'REBOOT'
        RESIZE = 'RESIZE'
        SHUTDOWN = 'SHUTDOWN'

        identity :id

        attribute :name
        attribute :created
        attribute :updated
        attribute :state, :aliases => 'status'
        attribute :hostname
        attribute :links
        attribute :flavor_id, :aliases => 'flavor', :squash => 'id'
        attribute :volume_size, :aliases => 'volume', :squash => 'size'

        attr_accessor :root_user, :root_password

        def save
          requires :name, :flavor_id, :volume_size
          data = connection.create_instance(name, flavor_id, volume_size)
          merge_attributes(data.body['instance'])
          true
        end

        def destroy
          requires :identity
          connection.delete_instance(identity)
          true
        end

        def flavor
          requires :flavor_id
          @flavor ||= connection.flavors.get(flavor_id)
        end

        def databases
          @databases ||= begin
            Fog::Rackspace::Databases::Databases.new({
              :connection => connection,
              :instance => self
            })
          end
        end

        def users
          @users ||= begin
            Fog::Rackspace::Databases::Users.new({
              :connection => connection,
              :instance => self
            })
          end
        end

        def ready?
          state == ACTIVE
        end

        def root_user_enabled?
          requires :identity
          connection.check_root_user(identity).body['rootEnabled']
        end

        def enable_root_user
          requires :identity
          data = connection.enable_root_user(identity).body['user']
          @root_user = data['name']
          @root_password = data['password']
          true
        end

        def restart
          requires :identity
          connection.restart_instance(identity)
          self.state = REBOOT
          true
        end

        def resize(flavor_id)
          requires :identity
          connection.resize_instance(identity, flavor_id)
          self.state = RESIZE
          true
        end

        def resize_volume(volume_size)
          requires :identity
          connection.resize_instance_volume(identity, volume_size)
          self.state = RESIZE
          true
        end
      end
    end
  end
end
