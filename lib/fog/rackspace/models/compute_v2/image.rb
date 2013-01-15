require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Image < Fog::Model
        UNKNOWN = 'UNKNOWN'
        ACTIVE = 'ACTIVE'
        SAVING = 'SAVING'
        ERROR = 'ERROR'
        DELETED = 'DELETED'

        identity :id

        attribute :name
        attribute :created
        attribute :updated
        attribute :state, :aliases => 'status'
        attribute :user_id
        attribute :tenant_id
        attribute :progress
        attribute :minDisk
        attribute :minRam
        attribute :disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :links
        
        ignore_attributes :metadata        
                
        def initialize(attributes={})
          @connection = attributes[:connection]
          super
        end
        
        def metadata
          raise "Please save image before accessing metadata" unless identity          
          @metadata ||= begin
            Fog::Compute::RackspaceV2::Metadata.new({
              :connection => connection,
              :parent => self
            })
          end
        end
        
        def metadata=(hash={})
          raise "Please save image before accessing metadata" unless identity
          metadata.from_hash(hash)
        end

        def ready?(ready_state = ACTIVE, error_states=[ERROR])
          if error_states
            error_states = Array(error_states)
            raise "Image should have transitioned to '#{ready_state}' not '#{state}'" if error_states.include?(state)
          end
          state == ready_state
        end
        

        def destroy
          requires :identity
          service.delete_image(identity)
        end
      end
    end
  end
end
