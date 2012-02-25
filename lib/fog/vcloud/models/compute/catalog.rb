module Fog
  module Vcloud
    class Compute
      class Catalog < Fog::Vcloud::Model

        identity :href, :aliases => :Href
        attribute :links, :aliases => :Link, :type => :array
        ignore_attributes :xmlns, :xmlns_i, :xmlns_xsi, :xmlns_xsd

        attribute :type
        attribute :name

        def catalog_items
          @catalog_items ||= Fog::Vcloud::Compute::CatalogItems.
            new( :connection => connection,
                 :href => href )
        end

      end
    end
  end
end
