module Fog
  module Generators
    module Compute
      module VcloudDirector
       
        class OrgVdcNetwork

          attr_reader :attrs

          def initialize(attrs={})
            @attrs = attrs
            
          end

          def generate_xml
            Nokogiri::XML::Builder.new do |xml|
              xml.OrgVdcNetwork( 'xmlns' => "http://www.vmware.com/vcloud/v1.5", 'name' => @attrs[:name]){
                xml.Configuration{
                  xml.IpScopes{
                    xml.IpScope{
                      xml.IsInherited  false
                      xml.Gateway  @attrs[:gateway]
                      xml.Netmask  @attrs[:netmask]
                      xml.Dns1  @attrs[:dns1]
                      xml.DnsSuffix @attrs[:dnssuffix]
                      xml.IpRanges{
                        xml.IpRange{
                          xml.StartAddress @attrs[:poolstartaddress]
                          xml.EndAddress @attrs[:poolendaddress]
                          
                        }
                      }
                    }
                  }
                  xml.FenceMode @attrs[:fencemode]
                    #TO DO IF NatRouted add GWID
                    
                  
                }
                
                if @attrs[:gatewayhref] && @attrs[:fencemode] == "natRouted"
                  
                  xml.EdgeGateway('href' => @attrs[:gatewayhref])
                  
                end
              }            
            end.to_xml
          end



          
        end
      end
    end
  end
end
