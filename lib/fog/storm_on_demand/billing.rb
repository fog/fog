require 'fog/billing'
require 'fog/storm_on_demand'
require 'fog/storm_on_demand/shared'

module Fog
  module Billing
    class StormOnDemand < Fog::Service

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storm_on_demand/models/billing'
      model      :invoice
      collection :invoices
      model      :payment
      collection :payments

      request_path 'fog/storm_on_demand/requests/billing'
      request :list_invoices
      request :get_invoice
      request :next_invoice
      request :make_payment

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