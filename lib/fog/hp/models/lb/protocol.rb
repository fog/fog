require 'fog/core/model'

module Fog
  module HP
    class LB
      class Protocol < Fog::Model
        identity :name
        attribute :port

        def destroy
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end

        def create(params)
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end

        def save
          raise Fog::HP::LB::NotFound.new('Operation not allowed.')
        end
      end
    end
  end
end
