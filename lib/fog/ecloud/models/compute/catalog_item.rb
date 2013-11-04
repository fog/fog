module Fog
  module Compute
    class Ecloud
      class CatalogItem < Fog::Ecloud::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :status, :aliases => :Status
        attribute :alerts, :aliases => :Alerts
        attribute :files, :aliases => :Files

        def configuration
          @configuration = Fog::Compute::Ecloud::CatalogConfigurations.new(:service => service, :href => "#{service.base_path}/admin/catalog/#{id}/configuration")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
