require 'fog/core/model'

module Fog
  module DNS
    class StormOnDemand

      class Domain < Fog::Model
        identity  :domain
        attribute :admin_handle
        attribute :bill_handle
        attribute :created
        attribute :expire
        attribute :ip
        attribute :registrar
        attribute :renewal_max_years
        attribute :renewal_status
        attribute :tech_handle
        attribute :updated

        def initialize(attributes={})
          super
        end

        def renew(years)
          requires :identity
          service.renew_domain(:domain => identity, :years => years)
          true
        end

      end

    end
  end
end
