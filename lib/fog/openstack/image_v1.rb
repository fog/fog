require 'fog/openstack/common'
require 'fog/openstack/core'
require 'fog/openstack/image'

module Fog
  module Image
    class OpenStack
      class V1 < Fog::Service

        SUPPORTED_VERSIONS = /v1(\.(0|1))*/

        requires :openstack_auth_url
        recognizes :openstack_auth_token, :openstack_management_url,
                   :persistent, :openstack_service_type, :openstack_service_name,
                   :openstack_tenant, :openstack_tenant_id,
                   :openstack_api_key, :openstack_username, :openstack_identity_endpoint,
                   :current_user, :current_tenant, :openstack_region,
                   :openstack_endpoint_type,
                   :openstack_project_name, :openstack_project_id,
                   :openstack_project_domain, :openstack_user_domain, :openstack_domain_name,
                   :openstack_project_domain_id, :openstack_user_domain_id, :openstack_domain_id,
                   :openstack_identity_prefix

        model_path 'fog/openstack/models/image_v1'

        model       :image
        collection  :images

        request_path 'fog/openstack/requests/image_v1'

        request :list_public_images
        request :list_public_images_detailed
        request :get_image
        request :create_image
        request :update_image
        request :get_image_members
        request :update_image_members
        request :get_shared_images
        request :add_member_to_image
        request :remove_member_from_image
        request :delete_image
        request :get_image_by_id
        request :set_tenant

        class Mock
          def self.data
            @data ||= Hash.new do |hash, key|
              hash[key] = {
                :images => {}
              }
            end
          end

          def self.reset
            @data = nil
          end

          def initialize(options={})
            @openstack_username = options[:openstack_username]
            @openstack_tenant   = options[:openstack_tenant]
            @openstack_auth_uri = URI.parse(options[:openstack_auth_url])

            @auth_token = Fog::Mock.random_base64(64)
            @auth_token_expiration = (Time.now.utc + 86400).iso8601

            management_url = URI.parse(options[:openstack_auth_url])
            management_url.port = 9292
            management_url.path = '/v1'
            @openstack_management_url = management_url.to_s

            @data ||= { :users => {} }
            unless @data[:users].find {|u| u['name'] == options[:openstack_username]}
              id = Fog::Mock.random_numbers(6).to_s
              @data[:users][id] = {
                'id'       => id,
                'name'     => options[:openstack_username],
                'email'    => "#{options[:openstack_username]}@mock.com",
                'tenantId' => Fog::Mock.random_numbers(6).to_s,
                'enabled'  => true
              }
            end
          end

          def data
            self.class.data[@openstack_username]
          end

          def reset_data
            self.class.data.delete(@openstack_username)
          end

          def credentials
            { :provider                 => 'openstack',
              :openstack_auth_url       => @openstack_auth_uri.to_s,
              :openstack_auth_token     => @auth_token,
              :openstack_region         => @openstack_region,
              :openstack_management_url => @openstack_management_url }
          end
        end

        class Real
          include Fog::OpenStack::Core

          def self.not_found_class
            Fog::Image::OpenStack::NotFound
          end
          include Fog::OpenStack::Common

          def initialize(options={})
            initialize_identity options

            @openstack_service_type           = options[:openstack_service_type] || ['image']
            @openstack_service_name           = options[:openstack_service_name]
            @openstack_endpoint_type          = options[:openstack_endpoint_type] || 'adminURL'

            @connection_options               = options[:connection_options] || {}

            authenticate

            process_path @openstack_management_uri
            unless @path.match(SUPPORTED_VERSIONS)
              @path = Fog::OpenStack.get_supported_version_path(SUPPORTED_VERSIONS,
                                                                 @openstack_management_uri,
                                                                 @auth_token,
                                                                 @connection_options)
            end

            @persistent = options[:persistent] || false
            @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
          end

          def process_path uri
            unless @path.match(SUPPORTED_VERSIONS)
              @path = "/" + Fog::OpenStack.get_supported_version(SUPPORTED_VERSIONS,
                                                                 uri,
                                                                 @auth_token,
                                                                 @connection_options)
            end
            @path
          end

          private

        end
      end
    end
  end
end
