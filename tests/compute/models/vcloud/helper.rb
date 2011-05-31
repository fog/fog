class Vcloud
  module Compute
    module TestSupport
      def self.template
        begin
          template_name = ENV['VCLOUD_TEMPLATE']
          raise unless template_name
          uri = Vcloud.catalogs.first.catalog_items.select {|ci| ci.name == template_name }[0].href
          raise unless uri
        rescue
          raise('Specify VApp template name in VCLOUD_TEMPLATE env var')
        end
        uri
      end
    end
    module Formats
    end
  end
end
