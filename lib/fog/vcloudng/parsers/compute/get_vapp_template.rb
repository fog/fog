#
# <?xml version="1.0" encoding="UTF-8"?>
# <VAppTemplate xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" ovfDescriptorUploaded="true" goldMaster="false" status="8" name="DEVWEB" id="urn:vcloud:vapptemplate:ed2b234f-c03f-460b-b877-bedd2255dfb3" type="application/vnd.vmware.vcloud.vAppTemplate+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#     <Link rel="catalogItem" type="application/vnd.vmware.vcloud.catalogItem+xml" href="https://example.com/api/catalogItem/5b3f97f1-13bf-450e-a632-126aac3bb3d9"/>
#     <Link rel="enable" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/action/enableDownload"/>
#     <Link rel="disable" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/action/disableDownload"/>
#     <Link rel="ovf" type="text/xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/ovf"/>
#     <Link rel="down" type="application/vnd.vmware.vcloud.owner+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/owner"/>
#     <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/metadata"/>
#     <Description>Windows Server 2008 R2 Web Edition</Description>
#     <Owner type="application/vnd.vmware.vcloud.owner+xml">
#         <User type="application/vnd.vmware.admin.user+xml" name="cthayer" href="https://example.com/api/admin/user/66b8c149-15e1-42f5-b391-2d0e6573a960"/>
#     </Owner>
#     <Children>
#         <Vm goldMaster="false" name="DEVWEB" id="urn:vcloud:vm:12af4ee1-04ad-4ae5-bab2-2d5db4296c85" type="application/vnd.vmware.vcloud.vm+xml" href="https://example.com/api/vAppTemplate/vm-12af4ee1-04ad-4ae5-bab2-2d5db4296c85">
#             <Link rel="up" type="application/vnd.vmware.vcloud.vAppTemplate+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3"/>
#             <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vAppTemplate/vm-12af4ee1-04ad-4ae5-bab2-2d5db4296c85/metadata"/>
#             <Description>Windows Server 2008 R2 Web Edition</Description>
#             <NetworkConnectionSection type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://example.com/api/vAppTemplate/vm-12af4ee1-04ad-4ae5-bab2-2d5db4296c85/networkConnectionSection/" ovf:required="false">
#                 <ovf:Info>Specifies the available VM network connections</ovf:Info>
#                 <PrimaryNetworkConnectionIndex>0</PrimaryNetworkConnectionIndex>
#                 <NetworkConnection network="none" needsCustomization="true">
#                     <NetworkConnectionIndex>0</NetworkConnectionIndex>
#                     <IsConnected>false</IsConnected>
#                     <MACAddress>00:50:56:98:77:23</MACAddress>
#                     <IpAddressAllocationMode>NONE</IpAddressAllocationMode>
#                 </NetworkConnection>
#             </NetworkConnectionSection>
#             <GuestCustomizationSection type="application/vnd.vmware.vcloud.guestCustomizationSection+xml" href="https://example.com/api/vAppTemplate/vm-12af4ee1-04ad-4ae5-bab2-2d5db4296c85/guestCustomizationSection/" ovf:required="false">
#                 <ovf:Info>Specifies Guest OS Customization Settings</ovf:Info>
#                 <Enabled>true</Enabled>
#                 <ChangeSid>false</ChangeSid>
#                 <VirtualMachineId>12af4ee1-04ad-4ae5-bab2-2d5db4296c85</VirtualMachineId>
#                 <JoinDomainEnabled>false</JoinDomainEnabled>
#                 <UseOrgSettings>false</UseOrgSettings>
#                 <AdminPasswordEnabled>false</AdminPasswordEnabled>
#                 <AdminPasswordAuto>true</AdminPasswordAuto>
#                 <ResetPasswordRequired>false</ResetPasswordRequired>
#                 <ComputerName>DEVWEB-001</ComputerName>
#             </GuestCustomizationSection>
#             <VAppScopedLocalId>DEVWEB</VAppScopedLocalId>
#         </Vm>
#     </Children>
#     <ovf:NetworkSection xmlns:ns12="http://www.vmware.com/vcloud/v1.5" ns12:href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/networkSection/" ns12:type="application/vnd.vmware.vcloud.networkSection+xml">
#         <ovf:Info>The list of logical networks</ovf:Info>
#         <ovf:Network ovf:name="none">
#             <ovf:Description>This is a special place-holder used for disconnected network interfaces.</ovf:Description>
#         </ovf:Network>
#     </ovf:NetworkSection>
#     <NetworkConfigSection type="application/vnd.vmware.vcloud.networkConfigSection+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/networkConfigSection/" ovf:required="false">
#         <ovf:Info>The configuration parameters for logical networks</ovf:Info>
#         <NetworkConfig networkName="none">
#             <Description>This is a special place-holder used for disconnected network interfaces.</Description>
#             <Configuration>
#                 <FenceMode>isolated</FenceMode>
#             </Configuration>
#             <IsDeployed>false</IsDeployed>
#         </NetworkConfig>
#     </NetworkConfigSection>
#     <LeaseSettingsSection type="application/vnd.vmware.vcloud.leaseSettingsSection+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/leaseSettingsSection/" ovf:required="false">
#         <ovf:Info>Lease settings section</ovf:Info>
#         <Link rel="edit" type="application/vnd.vmware.vcloud.leaseSettingsSection+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/leaseSettingsSection/"/>
#         <StorageLeaseInSeconds>7776000</StorageLeaseInSeconds>
#         <StorageLeaseExpiration>2013-09-11T15:53:20.900Z</StorageLeaseExpiration>
#     </LeaseSettingsSection>
#     <CustomizationSection type="application/vnd.vmware.vcloud.customizationSection+xml" href="https://example.com/api/vAppTemplate/vappTemplate-ed2b234f-c03f-460b-b877-bedd2255dfb3/customizationSection/" goldMaster="false" ovf:required="false">
#         <ovf:Info>VApp template customization section</ovf:Info>
#         <CustomizeOnInstantiate>true</CustomizeOnInstantiate>
#     </CustomizationSection>
# </VAppTemplate>

#module Boolean; end
#class TrueClass; include Boolean; end
#class FalseClass; include Boolean; end
#
#module Fog
#  module Parsers
#    module Compute
#      module Vcloudng
#
#
#
#        class GetVappTemplate < VcloudngParser
#          
#          
#
#          def customization_section
#  
#          end
#
#          def lease_settings_section
#  
#          end
#
#
#          def network_section
#  
#          end
#
#
#          def vm
#  
#          end
#
#          def children
#            {
#              'elements' => { 'Vm' => vm }
#            }
#          end
#
#          def link
#           { 
#             'attributes' => { 'rel' => String, 
#                               'type' => String,
#                               'href' => String 
#                             }
#           }
#          end
#                                                                
#
#
#          def owner
#            { 
#              'attributes' => { 'type' => String },
#              'elements' =>  { 'user' => user }
#            }
#          end
#
#          def user
#           { 
#             'elements' => { 'type' => String, 
#                             'name' => String, 
#                             'href' => String  
#                           }
#           }
#          end
#          
#          def vapp_template
#            { 
#              'attributes' => { 'goldMaster' => Boolean, 
#                               'status' => Integer, 
#                               'name' => String, 
#                               'type' => String, 
#                               'href' => String 
#                             },
#             'elements' => {  'Link' => link,
#                              'Description' => String,
#                              'Owner' => owner,
#                              'Children' => children,
#                              'NetworkSection' => network_section,
#                              'LeaseSettingsSection' => lease_settings_section,
#                              'CustomizationSection' => customization_section
#                            } 
#            
#            }
#          end
#          
#          @schema = { 'VAppTemplate' => vapp_template }
#
#          def reset
#            @response = { 'Links' => [], 'Children' => [] }
#            @current_path = []
#          end
#
#          def start_element(name, attributes)
#            super
#            if is_an_attribute?(name)
#              @last_element = name
#              current = extract_attributes(attributes)
#            else
#              @current_path << name if @current_path.last != name
#
#            end
#          end
#          
#          def end_element(name)
#            case name
#            when @schema['elements'].keys?
#              @schema['attributes'][name] ==
#            end
#          end
#
#        end
#
#      end
#    end
#  end
#end

module Fog
  module Parsers
    module Compute
      module Vcloudng



        class GetVappTemplate < VcloudngParser

          def reset
            @response = { 'Links' => [], 'Children' => [] }
            @in_children = false
            @in_network_connection_section = false
            @in_guest_customization_section = false
            @in_network_config = false
            @vm = {}
            @guest_customization_section = {}
            @network_connection_section = {}
            @network_connection = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'Link'
              link = extract_attributes(attributes)
              @response['Links'] << link
            when 'User'
              @response['Owner'] = extract_attributes(attributes)
            when 'VAppTemplate'
              vapp_template = extract_attributes(attributes)
              @response['name'] = vapp_template['name']
            when 'Children'
              @in_children = true
            when 'vm'
              vm_item = extract_attributes(attributes)
              @vm['name'] = vm_item['name']
              @vm['goldMaster'] = vm_item['goldMaster'].to_bool
              @vm['href'] = vm_item['href']
              @vm['id'] = vm_item['href'].split('/').last
            when 'NetworkConnectionSection'
              @in_network_connection_section = true
            when 'NetworkConnection'
              @in_network_connection = true
              network_connection_items = extract_attributes(attributes)
              @network_connection['network'] = network_connection_items['network']
              @network_connection['needsCustomization'] = network_connection_items['needsCustomization'].to_bool
            when 'NetworkConfig'
              @in_network_config = true
            when 'GuestCustomizationSection'
              guest_customization_item = extract_attributes(attributes)
              @guest_customization_section["href"] = guest_customization_item["href"]
              @guest_customization_section["required"] = guest_customization_item["required"].to_bool
              @guest_customization_section["type"] = guest_customization_item["type"]
              @in_guest_customization_section = true
            end
          end
          
          def end_element(name)
            if @in_children
              case name
              when 'Description'
                @vm['Description'] = value
              when 'NetworkConnection'
                @vm['NetworkConnectionSection'] ||= {}
                @vm['NetworkConnectionSection']['NetworkConnection'] = @network_connection
                @network_connection = {}
                @in_network_connection = false
              when 'NetworkConnectionSection'
                @vm['NetworkConnectionSection'].merge!(@network_connection_section)
                @network_connection_section = {}
                @in_network_connection_section = false
              when 'GuestCustomizationSection'
                @vm['GuestCustomizationSection'] = @guest_customization_section
                @guest_customization_section = {}
                @in_guest_customization_section = false
              when 'Vm'
                @response['Children'] << @vm
                @vm = {}
              when 'Children'
                @in_children = false
              end
              
              if @in_network_connection_section
                case name
                when 'PrimaryNetworkConnectionIndex'
                  @network_connection_section['PrimaryNetworkConnectionIndex'] = value.to_i
                when 
                  @network_connection['NetworkConnectionIndex'] = value.to_i
                when 'IsConnected'
                  @network_connection['IsConnected'] = value.to_bool
                when 'MACAddress', 'IpAddressAllocationMode'
                  @network_connection[name] = value
                end 
              end
              
              if @in_guest_customization_section
                case name
                when 'Enabled', 'ChangeSid', 'JoinDomainEnabled', 'UseOrgSettings', 'AdminPasswordEnabled', 'AdminPasswordAuto', 'ResetPasswordRequired'
                  @guest_customization_section[name] = value.to_bool
                when 'ComputerName', 'VirtualMachineId'
                  @guest_customization_section[name] = value
                end
              end
            else
              case name
              when 'Description'
                @response['Description'] = value
              end
            end
          end

        end

      end
    end
  end
end

