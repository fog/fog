module Fog
  module Compute
    class Exoscale
      class DiskOffering < Fog::Model
        identity  :id,              :aliases => 'id'
        attribute :created
        attribute :disk_size,       :aliases => 'disk_size'
        attribute :display_text,    :aliases => 'display_text'
        attribute :domain
        attribute :domain_id,       :aliases => 'domainid'
        attribute :is_customized,   :aliases => 'iscustomized'
        attribute :name
        attribute :storage_type,    :aliases => 'storagetype'
        attribute :tags

        def save
          raise Fog::Errors::Error.new('Creating a disk offering is not supported')
        end
        
        def destroy
          raise Fog::Errors::Error.new('Destroying a disk offering is not supported')
        end
      end # DiskOffering
    end # Exoscale
  end # Compute
end # Fog
