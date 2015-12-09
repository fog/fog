require 'fog/digitalocean/core'

module Fog
  module Compute
    class DigitalOceanV2 < Fog::Service
      requires :digitalocean_token

      model_path 'fog/digitalocean/models/compute_v2'
      model :server
      collection :servers
      model :image
      collection :images
      model :region
      collection :regions
      model :flavor
      collection :flavors
      model :ssh_key
      collection :ssh_keys

      request_path 'fog/digitalocean/requests/compute_v2'
      request :change_kernel
      request :create_server
      request :create_ssh_key
      request :delete_server
      request :delete_ssh_key
      request :disable_backups
      request :enable_ipv6
      request :enable_private_networking
      request :get_droplet_action
      request :get_image_details
      request :get_server_details
      request :get_ssh_key
      request :list_droplet_actions
      request :list_flavors
      request :list_images
      request :list_regions
      request :list_servers
      request :list_ssh_keys
      request :password_reset
      request :power_cycle
      request :power_off
      request :power_on
      request :reboot_server
      request :rebuild
      request :rename
      request :resize
      request :restore
      request :shutdown
      request :snapshot
      request :update_ssh_key
      request :upgrade


      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :servers  => [],
              :ssh_keys => []
            }
          end
        end

        def initialize(options={})
          @digitalocean_token = options[:digitalocean_token]
        end

        def data
          self.class.data[@digitalocean_token]
        end

        def reset_data
          self.class.data.delete(@digitalocean_token)
        end
      end

      class Real
        def initialize(options={})
          digitalocean_token = options[:digitalocean_token]
          persistent         = false
          options            = {
            headers: {
              'Authorization' => "Bearer #{digitalocean_token}",
            }
          }
          @connection        = Fog::Core::Connection.new 'https://api.digitalocean.com', persistent, options
        end

        def request(params)
          params[:headers] ||= {}
          begin
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                    when Excon::Errors::NotFound
                      Fog::Compute::Bluebox::NotFound.slurp(error)
                    else
                      error
                  end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
