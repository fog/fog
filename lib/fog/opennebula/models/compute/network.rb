require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula

      class Network < Fog::Model

        identity :id
        attribute :name
        attribute :uid
        attribute :gid

        def initialize(attributes = {})
          super
        end

        def save
          raise Fog::Errors::Error.new('Creating a new network is not yet implemented. Contributions welcome!')
        end

        def shutdown
	  raise Fog::Errors::Error.new('Shutting down a new network is not yet implemented. Contributions welcome!')
        end

      end

    end
  end

end
