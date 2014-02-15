require 'fog/storm_on_demand/core'
require 'fog/monitoring'
require 'fog/storm_on_demand/shared'

module Fog
  module Monitoring
    class StormOnDemand < Fog::Service
      
      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/monitoring'
      model       :load
      collection  :loads
      model       :bandwidth
      collection  :bandwidths
      model       :monitor_service
      collection  :monitor_services

      request_path 'fog/storm_on_demand/requests/monitoring'
      request :get_load_graph
      request :get_load_stats
      request :get_bandwidth_graph
      request :get_bandwidth_stats
      request :get_service
      request :monitoring_ips
      request :get_service_status
      request :update_service


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