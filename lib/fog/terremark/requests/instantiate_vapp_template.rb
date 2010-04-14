module Fog
  module Terremark
    class Real

      # Instatiate a vapp template
      #
      # ==== Parameters
      # * vdc_id<~Integer> - Id of vdc to instantiate template in
      # * options<~Hash>:
      #   * cpus<~Integer>: Number of cpus in [1, 2, 4, 8], defaults to 1
      #   * memory<~Integer>: Amount of memory either 512 or a multiple of 1024, defaults to 512
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:

      # FIXME

      #     * 'CatalogItems'<~Array>
      #       * 'href'<~String> - linke to item
      #       * 'name'<~String> - name of item
      #       * 'type'<~String> - type of item
      #     * 'description'<~String> - Description of catalog
      #     * 'name'<~String> - Name of catalog
      def instantiate_vapp_template(name, options = {})
        options['cpus'] ||= 1
        options['memory'] ||= 512

        # FIXME: much cheating to commence
        vdc_id        = default_vdc_id
        network_id    = default_network_id
        catalog_item  = 12 # Ubuntu JeOS 9.10 (64-bit)

        #       case UNRESOLVED:
        #          return "0";
        #       case RESOLVED:
        #          return "1";
        #       case OFF:
        #          return "2";
        #       case SUSPENDED:
        #          return "3";
        #       case ON:
        #          return "4";
        #       default:
        # 
        # /**
        #  * The vApp is unresolved (one or more file references are unavailable in the cloud)
        #  */
        # UNRESOLVED,
        # /**
        #  * The vApp is resolved (all file references are available in the cloud) but not deployed
        #  */
        # RESOLVED,
        # /**
        #  * The vApp is deployed and powered off
        #  */
        # OFF,
        # /**
        #  * The vApp is deployed and suspended
        #  */
        # SUSPENDED,
        # /**
        #  * The vApp is deployed and powered on
        #  */
        # ON;

        data = <<-DATA
<?xml version="1.0" encoding="UTF-8"?>
  <InstantiateVAppTemplateParams name="#{name}" xmlns="http://www.vmware.com/vcloud/v0.8" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v0.8 http://services.vcloudexpress.terremark.com/api/v0.8/ns/vcloud.xsd">
    <VAppTemplate href="https://services.vcloudexpress.terremark.com/api/v0.8/catalogItem/#{catalog_item}" />
    <InstantiationParams xmlns:vmw="http://www.vmware.com/schema/ovf">
      <ProductSection xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" xmlns:q1="http://www.vmware.com/vcloud/v0.8"/>
      <VirtualHardwareSection xmlns:q1="http://www.vmware.com/vcloud/v0.8">
        <Item xmlns="http://schemas.dmtf.org/ovf/envelope/1">
          <InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">1</InstanceID>
          <ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">3</ResourceType>
          <VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{options['cpus']}</VirtualQuantity>
        </Item>
        <Item xmlns="http://schemas.dmtf.org/ovf/envelope/1">
          <InstanceID xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">2</InstanceID>
          <ResourceType xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">4</ResourceType>
          <VirtualQuantity xmlns="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData">#{options['memory']}</VirtualQuantity>
        </Item>
      </VirtualHardwareSection>
      <NetworkConfigSection>
        <NetworkConfig name="Network 1">
          <Features>
            <vmw:FenceMode>allowInOut</vmw:FenceMode>
            <vmw:Dhcp>true</vmw:Dhcp>
          </Features>
          <NetworkAssociation href="https://services.vcloudexpress.terremark.com/api/v8/network/#{network_id}" />
        </NetworkConfig>
      </NetworkConfigSection>
    </InstantiationParams>
  </InstantiateVAppTemplateParams>
DATA

        request(
          :body     => data,
          :expects  => 200,
          :headers  => { 'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml' },
          :method   => 'POST',
          :parser   => Fog::Parsers::Terremark::InstantiateVappTemplate.new,
          :path     => "vdc/#{vdc_id}/action/instantiatevAppTemplate"
        )
      end

    end

    class Mock

      def instatiate_vapp_template(vapp_template_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
