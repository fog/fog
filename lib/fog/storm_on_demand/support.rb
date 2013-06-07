require 'fog/storm_on_demand'
require 'fog/support'
require 'fog/storm_on_demand/shared'

module Fog
  module Support

    class StormOnDemand < Fog::Service

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/support'
      model       :alert
      collection  :alerts
      model       :ticket
      collection  :tickets

      request_path 'fog/storm_on_demand/requests/support'
      request :get_active_alert
      request :add_feedback
      request :add_transaction_feedback
      request :authenticate
      request :close_ticket
      request :create_ticket
      request :get_ticket_details
      request :list_tickets
      request :reply_ticket
      request :list_ticket_types
      
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
