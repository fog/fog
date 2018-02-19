module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/NetworkConfigSectionType.html
        class NetworkConfigSection
          attr_reader :options

          def initialize(options={})
            @options = options
          end

          def generate_xml
            body = Nokogiri::XML::Builder.new do |xml|
              attrs = {
                :xmlns => 'http://www.vmware.com/vcloud/v1.5',
                'xmlns:ovf' => 'http://schemas.dmtf.org/ovf/envelope/1'
              }
              xml.NetworkConfigSection(attrs){
                xml['ovf'].Info
                options[:NetworkConfig].each do |network_config|
                  network_name = {networkName: network_config[:networkName]} if network_config[:networkName]
                  xml.NetworkConfig(network_name){
                    xml.Description network_config[:Description]
                    if configuration = network_config[:Configuration]
                      xml.Configuration {
                        if ipScopes = configuration[:IpScopes]
                          xml.IpScopes {
                            if ipScope = ipScopes[:IpScope]
                              xml.IpScope {
                                xml.IsInherited ipScope[:IsInherited]
                                xml.Gateway ipScope[:Gateway]
                                xml.Netmask ipScope[:Netmask]
                                xml.Dns1 ipScope[:Dns1] if ipScope[:Dns1]
                                xml.Dns2 ipScope[:Dns2] if ipScope[:Dns2]
                                xml.IsEnabled ipScope[:IsEnabled] if ipScope[:IsEnabled]
                                if ipRanges = ipScope[:IpRanges]
                                  xml.IpRanges {
                                    if ipRange = ipRanges[:IpRange]
                                      xml.IpRange {
                                        xml.StartAddress ipRange[:StartAddress]
                                        xml.EndAddress ipRange[:EndAddress]
                                      }
                                    end
                                  }
                                end
                              }
                            end
                          }
                        end
                        if parent_network = configuration[:ParentNetwork]
                          xml.ParentNetwork({href: parent_network[:href], id: parent_network[:id], name: parent_network[:name]})
                        end
                        xml.FenceMode configuration[:FenceMode] if configuration[:FenceMode]
                        xml.RetainNetInfoAcrossDeployments configuration[:RetainNetInfoAcrossDeployments] if configuration[:RetainNetInfoAcrossDeployments]
                      }
                    end #Configuraton
                    xml.IsDeployed configuration[:IsDeployed] if configuration[:IsDeployed]
                  }
                end
              }
            end.to_xml
          end
        end
      end
    end
  end
end
