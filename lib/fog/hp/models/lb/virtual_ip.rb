require 'fog/core/model'

module Fog
  module HP
    class LB
      class VirtualIp < Fog::Model
        identity :id

        attribute :address
        attribute :ip_version, :alias => 'ipVersion'
        attribute :type

        def destroy
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end

        def create(params)
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end

        def save
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end

        private

        def load_balancer
          collection.load_balancer
        end
      end
    end
  end
end
