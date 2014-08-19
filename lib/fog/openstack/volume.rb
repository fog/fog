require 'fog/openstack/core'

module Fog
  module Volume
    class OpenStack < Fog::Service
      requires :auth_url
      recognizes :auth_token, :management_url, :persistent,
                 :service_type, :service_name, :tenant,
                 :api_key, :username,
                 :current_user, :current_tenant,
                 :endpoint_type, :region

      model_path 'fog/openstack/models/volume'

      model       :volume
      collection  :volumes

      model       :volume_type
      collection  :volume_types

      request_path 'fog/openstack/requests/volume'

       # Volume
      request :list_volumes
      request :create_volume
      request :get_volume_details
      request :delete_volume

      request :list_volume_types
      request :get_volume_type_details

      request :create_volume_snapshot
      request :list_snapshots
      request :get_snapshot_details
      request :delete_snapshot

      request :update_quota
      request :get_quota
      request :get_quota_defaults

      request :set_tenant

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :users => {},
              :tenants => {},
              :quota => {
                'gigabytes' => 1000,
                'volumes'   => 10,
                'snapshots' => 10
              }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @username = options[:username]
          @tenant   = options[:tenant]
          @auth_uri = URI.parse(options[:auth_url])

          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          management_url = URI.parse(options[:auth_url])
          management_url.port = 8776
          management_url.path = '/v1'
          @management_url = management_url.to_s

          @data ||= { :users => {} }
          unless @data[:users].find {|u| u['name'] == options[:username]}
            id = Fog::Mock.random_numbers(6).to_s
            @data[:users][id] = {
              'id'       => id,
              'name'     => options[:username],
              'email'    => "#{options[:username]}@mock.com",
              'tenantId' => Fog::Mock.random_numbers(6).to_s,
              'enabled'  => true
            }
          end
        end

        def data
          self.class.data[@username]
        end

        def reset_data
          self.class.data.delete(@username)
        end

        def credentials
          { :provider                 => 'openstack',
            :auth_url       => @auth_uri.to_s,
            :auth_token     => @auth_token,
            :management_url => @management_url }
        end
      end

      class Real
        attr_reader :current_user
        attr_reader :current_tenant

        def initialize(options={})
          @auth_token = options[:auth_token]

          unless @auth_token
            missing_credentials = Array.new
            @api_key  = options[:api_key]
            @username = options[:username]

            missing_credentials << :api_key  unless @api_key
            missing_credentials << :username unless @username
            raise ArgumentError, "Missing required arguments: #{missing_credentials.join(', ')}" unless missing_credentials.empty?
          end

          @tenant               = options[:tenant]
          @auth_uri             = URI.parse(options[:auth_url])
          @management_url       = options[:management_url]
          @must_reauthenticate  = false
          @service_type         = options[:service_type] || ['volume']
          @service_name         = options[:service_name]
          @region               = options[:region]

          @endpoint_type        = options[:endpoint_type] || 'adminURL'
          @connection_options = options[:connection_options] || {}

          @current_user = options[:current_user]
          @current_tenant = options[:current_tenant]

          authenticate

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def credentials
          { :provider                 => 'openstack',
            :auth_url       => @auth_uri.to_s,
            :auth_token     => @auth_token,
            :management_url => @management_url,
            :current_user             => @current_user,
            :current_tenant           => @current_tenant }
        end

        def reload
          @connection.reset
        end

        def request(params)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :path     => "#{@path}/#{params[:path]}"#,
            }))
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          if !@management_url || @must_reauthenticate
            options = {
              :region   => @region,
              :tenant   => @tenant,
              :api_key  => @api_key,
              :username => @username,
              :auth_uri => @auth_uri,
              :auth_token => @auth_token,
              :service_type => @service_type,
              :service_name => @service_name,
              :endpoint_type => @endpoint_type
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @must_reauthenticate = false
            @auth_token = credentials[:token]
            @management_url = credentials[:server_management_url]
            uri = URI.parse(@management_url)
          else
            @auth_token = @auth_token
            uri = URI.parse(@management_url)
          end

          @host   = uri.host
          @path   = uri.path
          @path.sub!(/\/$/, '')
          @port   = uri.port
          @scheme = uri.scheme
          true
        end
      end
    end
  end
end
