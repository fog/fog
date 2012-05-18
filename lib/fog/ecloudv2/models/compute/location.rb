module Fog
  module Compute
    class Ecloudv2
      class Location < Fog::Ecloud::Model

        identity :href

        ignore_attributes :xmlns, :xmlns_xsi, :xmlns_xsd, :xmlns_i

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type

        def catalog(org_href)
          @catalog ||= Fog::Compute::Ecloudv2::Catalog.new(:connection => connection, :href => "/cloudapi/ecloud/admin/catalog/organizations/#{org_href.scan(/\d+/)[0]}/locations/#{id}")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
