require 'fog/core/model'

module Fog
  module Network
    class StormOnDemand

      class NetworkIP < Fog::Model
        identity :id

        attribute :broadcast
        attribute :gateway
        attribute :ip
        attribute :netmask
        attribute :reverse_dns

        def initialize(attributes={})
          super
        end

      end
    end
  end
end
