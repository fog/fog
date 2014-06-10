module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/index.jsp#types/ComposeVAppParamsType.html
        class ComposeVapp

          def initialize(configuration={})
            @configuration = configuration
          end

          def generate_xml
            Nokogiri::XML::Builder.new do |xml|
              
              attrs = {
                :xmlns => 'http://www.vmware.com/vcloud/v1.5',
                'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
              }

              [:deploy, :powerOn, :name].each { |a| attrs[a] = @configuration[a] if @configuration.key?(a) }

              xml.ComposeVAppParams(attrs) {
                build_vapp_instantiation_params(xml)
                build_template_source_items(xml)
                build_vm_source_items(xml)
              }

            end.to_xml
          end

          private

          def build_vapp_instantiation_params(xml)
            xml.Description @configuration[:Description]
            xml.AllEULAsAccepted (@configuration[:AllEULAsAccepted] || true)
            
            vapp = @configuration[:InstantiationParams]

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

          def build_template_source_items(xml)
            templates = @configuration[:source_templates]
            return unless templates
            templates.each do |template|
              xml.SourcedItem { xml.Source(:href => template[:href]) }
            end
          end

          def build_vm_source_items(xml)
            vms = @configuration[:source_vms]
            return unless vms
            vms.each do |vm|
              xml.SourcedItem {
                xml.Source(:href => vm[:href])
                xml.InstantiationParams {
                  if vm[:networks]
                    xml.NetworkConnectionSection(:href => "#{vm[:href]}/networkConnectionSection/", :type => "application/vnd.vmware.vcloud.networkConnectionSection+xml", 'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1", "ovf:required" => "false") {
                      xml['ovf'].Info
                      xml.PrimaryNetworkConnectionIndex 0
                      vm[:networks].each_with_index do |network, i|
                        xml.NetworkConnection(:network => network[:networkName]) {
                          xml.NetworkConnectionIndex i
                          xml.IsConnected network[:IsConnected]
                          xml.IpAddressAllocationMode network[:IpAddressAllocationMode]
                        }
                      end
                    }
                  end
                  if customization = vm[:guest_customization]
                    xml.GuestCustomizationSection(:xmlns => "http://www.vmware.com/vcloud/v1.5", 'xmlns:ovf' => "http://schemas.dmtf.org/ovf/envelope/1") {
                      xml['ovf'].Info
                      xml.Enabled (customization[:Enabled] || false)
                      xml.ComputerName customization[:ComputerName]
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
                      xml.CustomizationScript customization[:CustomizationScript] if (customization.key? :CustomizationScript)
                    }
                  end
                }
                xml.StorageProfile(:href => vm[:StorageProfileHref]) if (vm.key? :StorageProfileHref)
              }          
            end
          end
        end
      end
    end
  end
end