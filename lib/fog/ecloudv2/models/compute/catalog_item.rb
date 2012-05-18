module Fog
  module Compute
    class Ecloudv2
      class CatalogItem < Fog::Model
        identity :href

        attribute :name, :aliases => :Name
        attribute :type, :aliases => :Type
        attribute :other_links, :aliases => :Links
        attribute :status, :aliases => :Status
        attribute :alerts, :aliases => :Alerts
        attribute :files, :aliases => :Files

        def configuration
          @configuration = Fog::Compute::Ecloudv2::CatalogConfigurations.new(:connection => connection, :href => "/cloudapi/ecloud/admin/catalog/#{id}/configuration")
        end

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
