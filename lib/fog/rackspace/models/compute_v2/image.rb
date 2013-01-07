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

        def ready?
          state ==  ACTIVE
        end

        def destroy
          requires :identity
          connection.delete_image(identity)
        end
      end
    end
  end
end
