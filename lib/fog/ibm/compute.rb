require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ibm'))
require 'fog/compute'

module Fog
  module Compute
    class IBM < Fog::Service

      requires :ibm_user_id, :ibm_password
      recognizes :location

      model_path 'fog/ibm/models/compute'

      model :image
      collection :images
      model :server
      collection :servers
      model :address
      collection :addresses
      model :key
      collection :keys

      request_path 'fog/ibm/requests/compute'

      request :create_image
      request :clone_image
      request :delete_image
      request :get_images
      request :get_image
      request :get_image_agreement
      request :get_image_manifest
      # request :get_image_swbundles
      # request :get_image_swbundle

      request :create_instance
      request :delete_instance
      request :modify_instance
      request :get_instances
      request :get_instance
      request :get_instance_logs
      # request :get_instance_swbundle

      request :get_request

      request :create_address
      request :delete_address
      request :get_addresses
      request :get_address_offerings
      request :get_vlans

      request :create_key
      request :delete_key
      request :modify_key
      request :get_keys
      request :get_key

      class Real
        def initialize(options={})
          @connection = Fog::IBM::Connection.new(options[:ibm_user_id], options[:ibm_password])
        end

        private

        def request(options)
          begin
            @connection.request(options)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::IBM::NotFound.slurp(error)
            else
              error
            end
          end
        end
      end

      class Mock

        def request(options)
          Fog::Mock.not_implemented
        end

      end

    end
  end
end
