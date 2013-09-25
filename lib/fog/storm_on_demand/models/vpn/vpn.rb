require 'fog/core/model'

module Fog
  module VPN
    class StormOnDemand

      class Vpn < Fog::Model
        identity :uniq_id
        attribute :active
        attribute :activeStatus
        attribute :current_users
        attribute :domain
        attribute :max_users
        attribute :network_range
        attribute :region_id
        attribute :vpn

        def initialize(attributes={})
          super
        end

        def update(options={})
          requires :identity
          service.update_vpn({:uniq_id => identity}.merge!(options))
        end

      end
    end
  end
end
