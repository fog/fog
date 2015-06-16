require 'fog/openstack/core'

module Fog
  module Identity
    class OpenStack < Fog::Service

      # Fog::Identity::OpenStack.new() will return a Fog::Identity::OpenStack::V2 or a Fog::Identity::OpenStack::V3,
      #  depending on whether the auth URL is for an OpenStack Identity V2 or V3 API endpoint
      def self.new(args = {})
        if self.inspect == 'Fog::Identity::OpenStack'
          if args[:openstack_auth_url]
            @openstack_auth_uri = URI.parse(args[:openstack_auth_url])
            if @openstack_auth_uri.path =~ /\/v3/
              service = Fog::Identity::OpenStack::V3.new(args)
            end
          end
          service ||= Fog::Identity::OpenStack::V2.new(args)
        else
          service = Fog::Service.new(args)
        end
        service
      end

      module Common

        def authenticate
          if !@openstack_management_url || @openstack_must_reauthenticate
            options = {
                :openstack_api_key => @openstack_api_key,
                :openstack_username => @openstack_username,
                :openstack_userid => @openstack_userid,
                :openstack_domain_name => @openstack_domain_name,
                :openstack_domain_id => @openstack_domain_id,
                :openstack_project_name => @openstack_project_name,
                :openstack_auth_token => @openstack_must_reauthenticate ? nil : @openstack_auth_token,
                :openstack_auth_uri => @openstack_auth_uri,
                :openstack_tenant => @openstack_tenant,
                :openstack_service_type => @openstack_service_type,
                :openstack_service_name => @openstack_service_name,
                :openstack_endpoint_type => @openstack_endpoint_type,
                :openstack_region => @openstack_region
            }

            credentials = Fog::OpenStack.authenticate(options, @connection_options)

            @current_user = credentials[:user]
            @current_tenant = credentials[:tenant]

            @openstack_must_reauthenticate = false
            @auth_token = credentials[:token]
            @openstack_management_url = credentials[:server_management_url]
            @openstack_current_user_id = credentials[:current_user_id]
            @unscoped_token = credentials[:unscoped_token]
            uri = URI.parse(@openstack_management_url)
          else
            @auth_token = @openstack_auth_token
            uri = URI.parse(@openstack_management_url)
          end

          @host = uri.host
          @path = uri.path
          @path.sub!(/\/$/, '')
          @port = uri.port
          @scheme = uri.scheme
          true
        end

      end
    end


  end
end
