module Fog
  module Rackspace
    module Servers

      class Error < Fog::Errors::Error; end
      class NotFound < Fog::Errors::NotFound; end

      def self.new(options={})

        unless @required
          require 'fog/rackspace/models/servers/flavor'
          require 'fog/rackspace/models/servers/flavors'
          require 'fog/rackspace/models/servers/image'
          require 'fog/rackspace/models/servers/images'
          require 'fog/rackspace/models/servers/server'
          require 'fog/rackspace/models/servers/servers'
          require 'fog/rackspace/requests/servers/create_image'
          require 'fog/rackspace/requests/servers/create_server'
          require 'fog/rackspace/requests/servers/delete_image'
          require 'fog/rackspace/requests/servers/delete_server'
          require 'fog/rackspace/requests/servers/get_flavor_details'
          require 'fog/rackspace/requests/servers/get_image_details'
          require 'fog/rackspace/requests/servers/get_server_details'
          require 'fog/rackspace/requests/servers/list_addresses'
          require 'fog/rackspace/requests/servers/list_private_addresses'
          require 'fog/rackspace/requests/servers/list_public_addresses'
          require 'fog/rackspace/requests/servers/list_flavors'
          require 'fog/rackspace/requests/servers/list_flavors_detail'
          require 'fog/rackspace/requests/servers/list_images'
          require 'fog/rackspace/requests/servers/list_images_detail'
          require 'fog/rackspace/requests/servers/list_servers'
          require 'fog/rackspace/requests/servers/list_servers_detail'
          require 'fog/rackspace/requests/servers/reboot_server'
          require 'fog/rackspace/requests/servers/update_server'
          @required = true
        end

        if Fog.mocking?
          Fog::Rackspace::Servers::Mock.new(options)
        else
          Fog::Rackspace::Servers::Real.new(options)
        end
      end

      def self.reset_data(keys=Mock.data.keys)
        Mock.reset_data(keys)
      end

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified => {
                :images  => {},
                :servers => {}
              },
              :images  => {},
              :servers => {}
            }
          end
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @rackspace_username = options[:rackspace_username]
          @data = self.class.data[@rackspace_username]
        end

      end

      class Real

        def initialize(options={})
          credentials = Fog::Rackspace.authenticate(options)
          @auth_token = credentials['X-Auth-Token']
          uri = URI.parse(credentials['X-Server-Management-Url'])
          @host   = uri.host
          @path   = uri.path
          @port   = uri.port
          @scheme = uri.scheme
        end

        def request(params)
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}")

          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::Error => error
            raise case error
            when Excon::Errors::NotFound
              new_error = Fog::Rackspace::Servers::NotFound
              new_error.set_backtrace(error.backtrace)
              new_error.verbose = error.message
              new_error
            else
              error
            end
          end
          unless response.body.empty?
            response.body = JSON.parse(response.body)
          end
          response
        end

      end
    end
  end
end
