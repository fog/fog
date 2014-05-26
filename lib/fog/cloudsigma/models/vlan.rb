require 'fog/cloudsigma/nested_model'

module Fog
  module Compute
    class CloudSigma
      class VLAN < Fog::CloudSigma::CloudsigmaModel
        identity :uuid
        attribute :tags
        attribute :servers
        attribute :meta
        attribute :owner
        attribute :resource_uri, :type => :string
        attribute :subscription

        def update
          requires :identity
          data = attributes

          response = service.update_vlan(identity, data)

          new_attributes = response.body
          merge_attributes(new_attributes)
        end

        alias_method :save, :update
      end
    end
  end
end
