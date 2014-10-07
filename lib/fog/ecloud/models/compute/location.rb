module Fog
  module Compute
    class Ecloud
      class Location < Fog::Ecloud::Model
        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type

        def catalog(org_href)
          @catalog ||= Fog::Compute::Ecloud::Catalog.new(:service => service, :href => "#{service.base_path}/admin/catalog/organizations/#{org_href.scan(/\d+/)[0]}/locations/#{id}")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
