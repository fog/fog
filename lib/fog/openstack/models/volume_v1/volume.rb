require 'fog/openstack/models/volume/volume'

module Fog
  module Volume
    class OpenStack
      class V1
        class Volume < Fog::Volume::OpenStack::Volume
          identity :id

          superclass.attributes.each{|attrib| attribute attrib}
          attribute :display_name, :aliases => 'displayName'
          attribute :display_description, :aliases => 'displayDescription'
          attribute :tenant_id, :aliases => 'os-vol-tenant-attr:tenant_id'

          def save
            requires :display_name, :size
            data = service.create_volume(display_name, display_description, size, attributes)
            merge_attributes(data.body['volume'])
            true
          end

        end
      end
    end
  end
end
