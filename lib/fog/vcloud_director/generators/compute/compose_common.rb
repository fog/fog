module Fog
  module Generators
    module Compute
      module VcloudDirector
        module ComposeCommon

          def initialize(configuration={})
            @configuration = configuration
          end

          private

          def vapp_attrs
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5',
              'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
            }

            [:deploy, :powerOn, :name].each do |a|
              attrs[a] = @configuration[a] if @configuration.key?(a)
            end
            
            attrs
          end

          def has_source_items?
            (@configuration[:source_vms] && (@configuration[:source_vms].size > 0)) || 
            (@configuration[:source_templates] && (@configuration[:source_templates].size > 0))
          end

          def build_vapp_instantiation_params(xml)
            xml.Description @configuration[:Description] if @configuration[:Description]
            
            vapp = @configuration[:InstantiationParams]
            if vapp 
              xml.InstantiationParams {
                xml.DefaultStorageProfileSection {
                    xml.StorageProfile vapp[:DefaultStorageProfile]
                } if (vapp.key? :DefaultStorageProfile)
                xml.NetworkConfigSection {
                  xml['ovf'].Info
                  vapp[:NetworkConfig].each do |network|
                    xml.NetworkConfig(:networkName => network[:networkName]) {
                      xml.Configuration {
                        xml.ParentNetwork(:href => network[:networkHref])
                        xml.FenceMode network[:fenceMode]
                      }
                    }
                  end if vapp[:NetworkConfig]
                }
              }
            end
          end
          
          def build_source_template(xml)
            xml.Source(:href => @configuration[:Source])
          end

          def build_source_items(xml)
            vms = @configuration[:source_vms]
            vms.each do |vm|
              xml.SourcedItem {
                xml.Source(:name =>vm[:name], :href => vm[:href])
                xml.VmGeneralParams {
                  xml.Name vm[:name]
                  xml.Description vm[:Description] if vm[:Description]
                  xml.NeedsCustomization if vm[:NeedsCustomization]
                } if vm[:name]
                xml.InstantiationParams {
                  if vm[:networks]
                    xml.NetworkConnectionSection(:href => "#{vm[:href]}/networkConnectionSection/", :type => "application/vnd.vmware.vcloud.networkConnectionSection+xml", 'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1", "ovf:required" => "false") {
                      xml['ovf'].Info
                      xml.PrimaryNetworkConnectionIndex 0
                      vm[:networks].each_with_index do |network, i|
                        xml.NetworkConnection(:network => network[:networkName]) {
                          xml.NetworkConnectionIndex i
                          xml.IpAddress network[:IpAddress] if (network.key? :IpAddress)
                          xml.ExternalIpAddress network[:ExternalIpAddress] if (network.key? :ExternalIpAddress)
                          xml.IsConnected network[:IsConnected]
                          xml.MACAddress network[:MACAddress] if (network.key? :MACAddress)
                          xml.IpAddressAllocationMode network[:IpAddressAllocationMode]
                        }
                      end
                    }
                  end
                  if customization = vm[:guest_customization]
                    xml.GuestCustomizationSection(:xmlns => "http://www.vmware.com/vcloud/v1.5", 'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1") {
                      xml['ovf'].Info
                      xml.Enabled (customization[:Enabled] || false)
                      xml.ChangeSid customization[:ChangeSid] if (customization.key? :ChangeSid)
                      xml.JoinDomainEnabled customization[:JoinDomainEnabled] if (customization.key? :JoinDomainEnabled)
                      xml.UseOrgSettings customization[:UseOrgSettings] if (customization.key? :UseOrgSettings)
                      xml.DomainName customization[:DomainName] if (customization.key? :DomainName)
                      xml.DomainUserName customization[:DomainUserName] if (customization.key? :DomainUserName)
                      xml.DomainUserPassword customization[:DomainUserPassword] if (customization.key? :DomainUserPassword)
                      xml.MachineObjectOU customization[:MachineObjectOU] if (customization.key? :MachineObjectOU)
                      xml.AdminPasswordEnabled customization[:AdminPasswordEnabled] if (customization.key? :AdminPasswordEnabled)
                      xml.AdminPasswordAuto customization[:AdminPasswordAuto] if (customization.key? :AdminPasswordAuto)
                      xml.AdminPassword customization[:AdminPassword] if (customization.key? :AdminPassword)
                      xml.ResetPasswordRequired customization[:ResetPasswordRequired] if (customization.key? :ResetPasswordRequired)
                      xml.CustomizationScript CGI::escapeHTML(customization[:CustomizationScript]).gsub(/\r/, "&#13;") if (customization.key? :CustomizationScript)
                      xml.ComputerName customization[:ComputerName]
                    }
                  end
                }
                xml.StorageProfile(:href => vm[:StorageProfileHref]) if (vm.key? :StorageProfileHref)
              }
            end if vms

            templates = @configuration[:source_templates]
            templates.each do |template|
              xml.SourcedItem { xml.Source(:href => template[:href]) }
            end if templates

            xml.AllEULAsAccepted (@configuration[:AllEULAsAccepted] || true)
          end

        end
      end
    end
  end
end
