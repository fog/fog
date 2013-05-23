require 'fog/core/model'

module Fog
  module Storage
    class StormOnDemand

      class Volume < Fog::Model
        identity :uniq_id
        attribute :attachedTo
        attribute :cross_attach
        attribute :domain
        attribute :label
        attribute :size
        attribute :status
        attribute :zone

        def initialize(attributes={})
          super
        end

        def attach_to(server_id)
          requires :identity
          service.attach_volume_to_server(:uniq_id => identity,
                                          :to => server_id).body
        end

        def destroy
          requires :identity
          service.delete_volume(:uniq_id => identity)
          true
        end

        def detach_from(server_id)
          requires :identity
          service.detach_volume_from_server(:uniq_id => identity,
                                            :detach_from => server_id).body
        end

        def resize(new_size)
          requires :identity
          service.resize_volume(:uniq_id => identity,
                                :new_size => new_size).body
        end

        def update(options={})
          requires :identity
          service.update_volume({:uniq_id => identity}.merge!(options))
        end
        
      end

    end
  end
end
