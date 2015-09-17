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
          if (pub_net = networks['v4'].find { |n| n['type'] == 'public' })
            pub_net['ip_address']
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
      end
    end
  end
end
