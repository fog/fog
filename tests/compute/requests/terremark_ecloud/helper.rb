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
      @preferred_vdc ||= TerremarkEcloud[:compute].get_vdc(vdc_from_list(TerremarkEcloud[:compute].get_organization.body['vdcs'])['uri']).body
    end

    def self.preferred_catalog_item
      return @preferred_catalog_item if @preferred_catalog_item

      catalog = TerremarkEcloud[:compute].get_catalog(preferred_vdc['catalog_uri']).body
      catalog_item = catalog['catalogItems'].detect do |item|
        item['name'] == 'Ubuntu Server 10.04 x32'
      end

      @preferred_catalog_item = TerremarkEcloud[:compute].get_catalog_item(catalog_item['uri']).body
    end

    def self.preferred_network
      return @preferred_network if @preferred_network

      preferred_vdc['networks'].detect do |network|
        fetched_network = TerremarkEcloud[:compute].get_network(network['uri']).body
        network_extensions_uri = fetched_network['extensions_uri']
        if TerremarkEcloud[:compute].get_network_extensions(network_extensions_uri).body['type'] == 'DMZ'
          return @preferred_network = fetched_network
        end
      end
    end

    def self.create_vm!(options = {})
      data = TerremarkEcloud[:compute].instantiate_vm_template({
          'vdc_uri' => preferred_vdc['uri'],
          'catalog_item_uri' => preferred_catalog_item['uri'],
          'network_uri' => preferred_network['uri'],
          'name' => options['name'] || "fogtest-#{rand(99999)}",
          'row' => options['row'] || 'fogtest',
          'group' => options['group'] || 'fogtest'
        }).body

      if options[:wait_for_powered_off]
        Fog.wait_for(600, 10) do
          TerremarkEcloud[:compute].get_vm(data['uri']).body['status'] == 'powered_off'
        end
      end

      data
    end

  end

end
