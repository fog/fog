class TerremarkEcloud

  module Compute

    def self.vdc_from_list(vdc_list)
      if matcher = ENV['VDC_NAME_MATCHER']
        vdc_list.detect {|v| v['name'] =~ /#{Regexp.escape(matcher)}/ }
      else
        vdc_list.first
      end
    end

    def self.preferred_vdc
      @preferred_vdc ||= begin
        href = vdc_from_list(TerremarkEcloud[:compute].get_organization.body['Link'])['href']
        TerremarkEcloud[:compute].get_vdc(href).body
      end
    end

    def self.preferred_catalog
      @preferred_catalog ||= begin
        catalog_href = preferred_vdc['Link'].detect {|link| link['type'] == 'application/vnd.vmware.vcloud.catalog+xml' }['href']
        TerremarkEcloud[:compute].get_catalog(catalog_href).body
      end
    end

    def self.preferred_catalog_item
      @preferred_catalog_item ||= begin
        catalog_item = preferred_catalog['CatalogItems'].detect do |item|
          item['name'] == 'Ubuntu Server 10.04 x32'
        end
        TerremarkEcloud[:compute].get_catalog_item(catalog_item['href']).body
      end
    end

    def self.preferred_network
      @preferred_network ||= begin
        network_href = preferred_vdc['AvailableNetworks'].first['href']
        TerremarkEcloud[:compute].get_network(network_href).body
      end
    end

  end

end
