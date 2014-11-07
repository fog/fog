require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula
      class Interface < Fog::Model

        identity :id
        attribute :vnet
        attribute :model
        attribute :name
        attribute :mac

        def save
          raise Fog::Errors::Error.new('Creating a new interface is not yet implemented. Contributions welcome!')
        end
 
        def vnetid
          return vnet
        end

        def persisted?
          mac
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying an interface is not yet implemented. Contributions welcome!')
        end

      end
    end
  end
end
