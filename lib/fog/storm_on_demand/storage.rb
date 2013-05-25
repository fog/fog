require "fog/storm_on_demand"
require "fog/storage"
require "fog/storm_on_demand/shared"

module Fog
  module Storage
    class StormOnDemand < Fog::Service

      API_URL = 'https://api.stormondemand.com'
      API_VERSION = 'v1'

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/storage'
      model       :cluster
      collection  :clusters
      model       :volume
      collection  :volumes

      request_path 'fog/storm_on_demand/requests/storage'
      request :list_clusters
      request :attach_volume_to_server
      request :create_volume
      request :delete_volume
      request :detach_volume_from_server
      request :get_volume
      request :list_volumes
      request :resize_volume
      request :update_volume

      class Mock

        def self.data
          @data ||= Hash.new
        end

        def self.reset
          @data = nil
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options={})
          @storm_on_demand_username = options[:storm_on_demand_username]
        end

        def data
          self.class.data[@storm_on_demand_username]
        end

        def reset_data
          self.class.data.delete(@storm_on_demand_username)
        end

      end

      class Real

        include Fog::StormOnDemand::RealShared

      end
    end
  end
end
