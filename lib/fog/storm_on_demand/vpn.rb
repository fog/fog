require 'fog/storm_on_demand'
require 'fog/storm_on_demand/shared'
require 'fog/vpn'

module Fog
  module VPN
    class StormOnDemand < Fog::Service
      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/vpn'
      model       :vpn
      collection  :vpns

      request_path 'fog/storm_on_demand/requests/vpn'
      request :create_vpn
      request :get_vpn
      request :list_vpn_users
      request :update_vpn

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
