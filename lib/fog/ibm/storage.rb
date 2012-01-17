require File.expand_path(File.join(File.dirname(__FILE__), '..', 'ibm'))
require 'fog/storage'

module Fog
  module Storage
    class IBM < Fog::Service

      requires :ibm_user_id, :ibm_password
      recognizes :location

      model_path 'fog/ibm/models/storage'

      model :offering
      collection :offerings
      model :volume
      collection :volumes

      request_path 'fog/ibm/requests/storage'

      request :list_offerings

      request :list_volumes
      request :create_volume
      request :delete_volume
      request :get_volume

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
              Fog::Storage::IBM::NotFound.slurp(error)
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
