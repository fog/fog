require 'fog/core/model'

module Fog
  module Compute
    class OpenNebula

      class Nic < Fog::Model

        identity :id
        attribute :vnet
        attribute :model

	def uuid
	  :id
	end

        def initialize attributes = {}
          super defaults.merge(attributes)
        end

        def save
          raise Fog::Errors::Error.new('Creating a new nic is not yet implemented. Contributions welcome!')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying an interface is not yet implemented. Contributions welcome!')
        end

        private
        def defaults
          {
            :model => "virtio"
          }
        end

      end

    end
  end

end
