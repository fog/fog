require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOceanV2
      # A DigitalOcean Droplet
      #
      class Server < Fog::Compute::Server
        identity :id
        attribute :name
        attribute :memory
        attribute :vcpus
        attribute :disk
        attribute :locked
        attribute :created_at
        attribute :status
        attribute :backup_ids
        attribute :snapshot_ids
        attribute :features
        attribute :region
        attribute :image
        attribute :size
        attribute :size_slug
        attribute :networks
        attribute :kernel
        attribute :next_backup_window
        attribute :private_networking
        attribute :backups
        attribute :ipv6
        attribute :ssh_keys

        def public_ip_address
          ipv4_address
        end

        def ipv6_address
          if (net = networks['v6'].find { |n| n['type'] == 'public' })
            net['ip_address']
          end
        end

        def ipv4_address
          if (net = networks['v4'].find { |n| n['type'] == 'public' })
            net['ip_address']
          end
        end

        def save
          raise Fog::Errors::Error.new('Re-saving an existing object may create a duplicate') if persisted?
          requires :name, :region, :size, :image

          options = {}
          if attributes[:ssh_keys]
            options[:ssh_keys] = attributes[:ssh_keys]
          elsif @ssh_keys
            options[:ssh_keys] = @ssh_keys.map(&:id)
          end

          options[:private_networking] = private_networking
          options[:backups]            = backups
          options[:ipv6]               = ipv6

          data = service.create_server(name, size, image, region, options)

          merge_attributes(data.body['droplet'])
          true
        end

        def delete
          requires :id
          response = service.delete_server id
          response.body
        end

        def ready?
          status == 'active'
        end

        def locked?
          locked
        end

        def actions
          requires :id
          response = service.list_droplet_actions id
          response.body
        end

        def action(action_id)
          requires :id
          response = service.get_droplet_action(id, action_id)
          response.body
        end

        def reboot
          perform_action :reboot_server
        end

        def disable_backups
          perform_action :disable_backups
        end

        def power_cycle
          perform_action :power_cycle
        end

        def shutdown
          perform_action :shutdown
        end

        def power_off
          perform_action :power_off
        end

        def power_on
          perform_action :power_on
        end

        def restore(image)
          perform_action :restore, image
        end

        def password_reset
          perform_action :password_reset
        end

        def resize(resize_disk, size)
          perform_action :resize, resize_disk, size
        end

        def rebuild(image)
          perform_action :rebuild, image
        end

        def rename(name)
          perform_action :rename, name
        end

        def change_kernel(kernel)
          perform_action :change_kernel, kernel
        end

        def enable_ipv6
          perform_action :enable_ipv6
        end

        def enable_private_networking
          perform_action :enable_private_networking
        end

        def snapshot(name)
          perform_action :snapshot, name
        end

        def upgrade
          perform_action :upgrade
        end

        private

        # Performs a droplet action with the given set of arguments.
        def perform_action(action, *args)
          requires :id
          response = service.send(action, id, *args)
          response.body
        end
      end
    end
  end
end
