module Fog
  module Compute
    module Helper
      
      def catalog_item_end_point(catalog_item_id = nil)
        end_point + ( catalog_item_id ? "catalogItem/#{catalog_item_id}" : "catalogItem" )
      end
      
      def network_end_point(network_id = nil)
        end_point + ( network_id ? "network/#{network_id}" : "network" )
      end
      
      def vapp_template_end_point(vapp_template_id = nil)
        end_point + ( vapp_template_id ? "vAppTemplate/#{vapp_template_id}" : "vAppTemplate" )
      end
      
      def vdc_end_point(vdc_id = nil)
        end_point + ( vdc_id ? "vdc/#{vdc_id}" : "vdc" )
      end
      
      def endpoint
        end_point
      end
      
      #  A single organization can have multiple Org vDCs.
      def default_vdc_id
        if default_organization_id
          @default_vdc_id ||= begin
            vdcs = default_organization_body[:Link].select {|link|
              link[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
            }
            if vdcs.length == 1
              vdcs.first[:href].split('/').last
            else
              nil
            end
          end
        else
          nil
        end
      end
      
      #  A single organization can have multiple Org vDCs.
      def default_vdc_body
        return nil unless default_vdc_id
        @default_vdc_body ||= begin
          response = get_vdc(default_vdc_id)
          return nil unless response.respond_to? 'data'
          response.data[:body]
        end
      end
      
      def default_network_name
        return nil unless default_vdc_body
        return nil unless network = default_vdc_body[:AvailableNetworks][:Network]
        network["name"]
      end

      def default_network_id
        return nil unless default_vdc_body
        return nil unless network = default_vdc_body[:AvailableNetworks][:Network]
        network[:href].split('/').last
      end
      
      def default_network_name
        if default_vdc_id
          @default_network_name ||= begin
            network = default_vdc_body[:AvailableNetworks][:Network]
            network[:name]
          end
        end
      end
      
      def default_organization_id
        @default_organization_id ||= begin
          org = get_organizations.body[:Org]
          return nil unless org[:href]
          org[:href].split('/').last
        end
      end

      def default_organization_body
        return nil unless default_organization_id
        @default_organization_body ||= begin
        response = get_organization(default_organization_id)
        return nil unless response.respond_to? 'body'
        response.body
        end
      end
      
    end
  end
end
        