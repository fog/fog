require 'fog/openstack/models/volume/volume'


module Fog
  module Volume
    class OpenStack
      class V2
        class Volume < Fog::Volume::OpenStack::Volume
          identity :id

          superclass.attributes.each{|attrib| attribute attrib}
          attribute :name
          attribute :description
          attribute :tenant_id, :aliases => 'os-vol-tenant-attr:tenant_id'

          def save
            requires :name, :size
            data = service.create_volume(name, description, size, attributes)
            merge_attributes(data.body['volume'])
            true
          end

        end
      end
    end
  end
end
