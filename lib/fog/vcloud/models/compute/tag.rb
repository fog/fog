module Fog
  module Vcloud
    class Compute
      class Tag < Fog::Vcloud::Model
        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :key, :aliases => :Key
        attribute :value, :aliases => :Value

        def destroy
          service.delete_metadata(href)
        end
      end
    end
  end
end
