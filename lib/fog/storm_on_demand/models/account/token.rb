require 'fog/core/model'

module Fog
  module Account
    class StormOnDemand
      class Token < Fog::Model
        attribute :token
        attribute :expires

        def initialize(attributes={})
          super
        end

        def expire
          service.expire_token.body['expired'].to_i == 1 ? true : false
        end
      end
    end
  end
end
