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

      request_path 'fog/digitalocean/requests/compute_v2'
      request :get_server_details
      request :list_servers
      request :list_images
      request :list_regions
      request :list_flavors
      request :create_server
      request :delete_server

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
                :servers => [],
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
          persistent = false
          options = {
              headers: {
                  'Authorization' => "Bearer #{digitalocean_token}",
              }
          }
          @connection = Fog::Core::Connection.new 'https://api.digitalocean.com', persistent, options
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