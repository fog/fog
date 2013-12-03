require 'fog/core/collection'
require 'fog/storm_on_demand/models/account/token'

module Fog
  module Account
    class StormOnDemand

      class Tokens < Fog::Collection
        model Fog::Account::StormOnDemand::Token

        def create(options={})
          t = service.create_token(options).body
          new(t)
        end

      end

    end
  end
end
