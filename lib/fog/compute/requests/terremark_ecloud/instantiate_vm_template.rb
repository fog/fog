module Fog
  module TerremarkEcloud
    class Compute

      class Real

        require 'fog/compute/parsers/terremark_ecloud/instantiate_vm_template'

        # Instantiate a VM template
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'vdc_uri'<~String>: URI of the VDC to place the VM in (required)
        #   * 'catalog_item_uri'<~String>: URI of the catalog item (template) to use (required)
        #   * 'network_uri'<~String>: URI of the network to place the VM in (required)
        #   * 'name'<~String>: Name of the VM to create
        #   * 'row'<~String>: UI row to place the VM in (required)
        #   * 'group'<~String>: UI group to place the VM in (required)
        #   * 'cpus'<~Integer>: Number of CPUs the VM should have (defaults to 1)
        #   * 'memory'<~Integer>: Megabytes of memory the VM should have (defaults to 512)
        #   * 'ipAddress'<~String>: IP to use within the network
        #   * 'longName'<~String>: Long name for the VM
        #   * 'tags'<~Array>: Tags to assign to the VM
        #   * 'password'<~String>: Password
        def instantiate_vm_template(options = {})
          options['cpus']   ||= 1
          options['memory'] ||= 512

          required_options = %w(vdc_uri catalog_item_uri network_uri name row group)
          supplied_options = options.keys
          missing_options  = required_options - supplied_options

          unless missing_options.empty?
            raise ArgumentError, "Missing required options: #{missing_options.sort.join(', ')}"
          end

          # could take parsed catalog_item Hash instead/also to avoid this
          template_uri = get_catalog_item(options['catalog_item_uri']).body['template_uri']

          builder = Builder::XmlMarkup.new
          body_xml = builder.InstantiateVAppTemplateParams({
                                                             'name' => options['name'],
                                                             'xmlns' => 'http://www.vmware.com/vcloud/v0.8',
                                                             'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                                                             'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
                                                             'xml:lang' => 'en'
                                                           }) do |b|
            b.VAppTemplate(:href => template_uri)
            b.InstantiationParams do
              b.ProductSection({
                                 'xmlns:q1' => 'http://www.vmware.com/vcloud/v0.8',
                                 'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
                               }) do
                b.Property({
                             'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                             'ovf:key' => 'row',
                             'ovf:value' => options['row']
                           })
                b.Property({
                             'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                             'ovf:key' => 'group',
                             'ovf:value' => options['group']
                           })
                if options['password']
                  b.Property({
                               'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                               'ovf:key' => 'password',
                               'ovf:value' => options['password']
                             })
                end
                if options['ipAddress']
                  b.Property({
                               'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                               'ovf:key' => 'ipaddress',
                               'ovf:value' => options['ipAddress']
                             })
                end
                if options['longName']
                  b.Property({
                               'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                               'ovf:key' => 'longName',
                               'ovf:value' => options['longName']
                             })
                end
                if options['tags']
                  b.Property({
                               'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1',
                               'ovf:key' => 'tags',
                               'ovf:value' => options['tags'].join(',') # groan
                             })
                end
              end # ProductSection

              b.VirtualHardwareSection({
                                         'xmlns:q1' => 'http://www.vmware.com/vcloud/v0.8'
                                       }) do
                b.Item({
                         'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1'
                       }) do
                  b.InstanceID(2, 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                  b.ResourceType(4, 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                  b.VirtualQuantity(options['memory'], 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                end
                b.Item({
                         'xmlns' => 'http://schemas.dmtf.org/ovf/envelope/1'
                       }) do
                  b.InstanceID(1, 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                  b.ResourceType(3, 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                  b.VirtualQuantity(options['cpus'], 'xmlns' => 'http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData')
                end
              end # VirtualHardwareSection

              b.NetworkConfigSection do
                b.NetworkConfig do
                  b.NetworkAssociation(:href => options['network_uri'])
                end
              end
            end # InstantiationParams
          end # InstantiateVAppTemplateParams

          request({
                    :uri        => options['vdc_uri'] + '/action/instantiatevAppTemplate',
                    :method     => 'POST',
                    :headers    => {
                      'Content-Type' => 'application/vnd.vmware.vcloud.instantiateVAppTemplateParams+xml'
                    },
                    :body       => body_xml,
                    :parser     => Fog::Parsers::TerremarkEcloud::Compute::InstantiateVmTemplate.new
                  })
        end

      end
    end
  end
end
