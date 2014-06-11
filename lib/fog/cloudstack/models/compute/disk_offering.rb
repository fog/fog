module Fog
  module Compute
    class Cloudstack
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
          requires :display_text, :name

          options = {
            'displaytext' => display_text,
            'name'        => name,
            'customized'  => is_customized,
            'disksize'    => disk_size,
            'domain_id'   => domain_id,
            'storagetype' => storage_type,
            'tags'        => tags
          }

          response = service.create_disk_offering(options)
          merge_attributes(response['creatediskofferingresponse'])
        end

        def destroy
          requires :id

          response = service.delete_disk_offering('id' => id )
          success_status = response['deletediskofferingresponse']['success']

          success_status == 'true'
        end
      end # DiskOffering
    end # Cloudstack
  end # Compute
end # Fog
