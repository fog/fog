require 'fog/core/model'

module Fog
  module Network
    class StormOnDemand

      class Pool < Fog::Model
        identity :uniq_id
        attribute :accnt
        attribute :assignments
        attribute :id
        attribute :zone_id

        def initialize(attributes={})
          super
        end

        def destroy
          requires :identity
          service.delete_pool(:uniq_id => identity)
          true
        end

        def update(options={})
          requires :identity
          service.update_pool({:uniq_id => identity}.merge!(options))
        end
        
      end
    end
  end
end
