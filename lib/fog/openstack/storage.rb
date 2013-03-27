require 'fog/openstack'
require 'fog/storage'

module Fog
  module Storage
    class OpenStack < Fog::Service

      requires   :openstack_auth_url, :openstack_username,
                 :openstack_api_key
      recognizes :persistent, :openstack_service_name,
                 :openstack_service_type, :openstack_tenant,
                 :openstack_region

      model_path 'fog/openstack/models/storage'
      model       :directory
      collection  :directories
      model       :file
      collection  :files

      request_path 'fog/openstack/requests/storage'
      request :copy_object
      request :delete_container
      request :delete_object
      request :get_container
      request :get_containers
      request :get_object
      request :get_object_https_url
      request :head_container
      request :head_containers
      request :head_object
      request :put_container
      request :put_object
      request :put_object_manifest

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          require 'mime/types'
          @openstack_api_key = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
          @path = '/v1/AUTH_1234'
        end

        def data
          self.class.data[@openstack_username]
        end

        def reset_data
          self.class.data.delete(@openstack_username)
        end
        
        def change_account(account)
          @original_path ||= @path
          version_string = @original_path.split('/')[1]
          @path = "/#{version_string}/#{account}"
        end

        def reset_account_name
          @path = @original_path
        end

      end

      class Real

        def initialize(options={})
          require 'mime/types'
          @openstack_api_key = options[:openstack_api_key]
          @openstack_username = options[:openstack_username]
          @openstack_auth_url = options[:openstack_auth_url]
          @openstack_auth_token = options[:openstack_auth_token]
          @openstack_storage_url = options[:openstack_storage_url]
          @openstack_must_reauthenticate = false
          @openstack_service_type = options[:openstack_service_type] || 'object-store'
          @openstack_service_name = options[:openstack_service_name]
          @openstack_region       = options[:openstack_region]
          @openstack_tenant       = options[:openstack_tenant]
          @connection_options     = options[:connection_options] || {}
          authenticate
          @persistent = options[:persistent] || false
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        # Change the current account while re-using the auth token.
        #
        # This is usefull when you have an admin role and you're able
        # to HEAD other user accounts, set quotas, list files, etc.
        #
        # For example:
        #
        #     # List current user account details
        #     service = Fog::Storage[:openstack]
        #     service.request :method => 'HEAD'
        #     
        # Would return something like:
        #
        #     Account:                      AUTH_1234
        #     Date:                         Tue, 05 Mar 2013 16:50:52 GMT
        #     X-Account-Bytes-Used:         0 (0.00 Bytes)
        #     X-Account-Container-Count:    0
        #     X-Account-Object-Count:       0
        #
        # Now let's change the account
        #
        #     service.change_account('AUTH_3333')
        #     service.request :method => 'HEAD'
        # 
        # Would return something like:
        #     
        #     Account:                      AUTH_3333
        #     Date:                         Tue, 05 Mar 2013 16:51:53 GMT
        #     X-Account-Bytes-Used:         23423433
        #     X-Account-Container-Count:    2
        #     X-Account-Object-Count:       10
        #
        # If we wan't to go back to our original admin account:
        #
        #     service.reset_account_name
        # 
        def change_account(account)
          @original_path ||= @path 
          version_string = @path.split('/')[1]
          @path = "/#{version_string}/#{account}"
        end

        def reset_account_name
          @path = @original_path
        end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::Unauthorized => error
            if error.response.body != 'Bad username or password' # token expiration
              @openstack_must_reauthenticate = true
              authenticate
              retry
            else # bad credentials
              raise error
            end
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Storage::OpenStack::NotFound.slurp(error)
            else
              error
            end
          end
          if !response.body.empty? && parse_json && response.headers['Content-Type'] =~ %r{application/json}
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private
        
        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
              :openstack_api_key  => @openstack_api_key,
              :openstack_username => @openstack_username,
              :openstack_auth_uri => URI.parse(@openstack_auth_url),
              :openstack_service_type => @openstack_service_type,
              :openstack_service_name => @openstack_service_name,
              :openstack_region => @openstack_region,
              :openstack_tenant => @openstack_tenant,
              :openstack_endpoint_type => 'publicURL'
            }

            credentials = Fog::OpenStack.authenticate_v2(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
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
