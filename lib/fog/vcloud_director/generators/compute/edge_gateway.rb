module Fog
  module Generators
    module Compute
      module VcloudDirector
        class EdgeGateway
          def initialize(configuration={})
            @configuration = configuration
          end

          def generate_xml
            firewall_config = @configuration[:firewall_service]
            nat_config = @configuration[:nat_service]
            body = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
              EdgeGatewayServiceConfiguration(
                  'xmlns' => "http://www.vmware.com/vcloud/v1.5",
                  'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                  'xsi:schemaLocation' => "http://www.vmware.com/vcloud/v1.5 http://vendor-api-url.net/v1.5/schema/master.xsd"
              ) {
                FirewallService {
                  IsEnabled 'true'
                  #DefaultAction firewall_config[:default_action]
                  #LogDefaultAction firewall_config[:log_default_action]
                  firewall_config[:rules].each do |rule|
                    FirewallRule {
                      Id rule[:id]
                      #IsEnabled rule[:is_enabled]
                      #MatchOnTranslate rule[:match_on_translate]
                      Description rule[:description]
                      Policy rule[:policy]

                      Protocols {
                        rule[:protocols].each do |protocol|
                          send(protocol.to_s.capitalize, true)
                        end
                      }

                      if rule[:protocols].include? :icmp
                        IcmpSubType "any"
                      end

                      Port rule[:destination][:port] == "Any" ? "-1" : rule[:destination][:port]
                      DestinationPortRange rule[:destination][:port]
                      DestinationIp rule[:destination][:ip]
                      SourcePort rule[:source][:port] == "Any" ? "-1" : rule[:source][:port]
                      SourcePortRange rule[:source][:port]
                      SourceIp rule[:source][:ip]
                    }

                  end
                } if firewall_config

                NatService {
                  IsEnabled nat_config[:is_enabled]

                  nat_config[:rules].each do |rule|
                    NatRule {
                      RuleType rule[:rule_type]
                      IsEnabled rule[:is_enabled]
                      Id rule[:id]
                      GatewayNatRule {
                        Interface('type' => "application/vnd.vmware.admin.network+xml", 'name' => rule[:interface][:name], 'href' => rule[:interface][:href])
                        OriginalIp rule[:original][:ip]
                        if rule[:original][:port]
                          OriginalPort rule[:original][:port]
                        end

                        TranslatedIp rule[:translated][:ip]
                        if rule[:translated][:port]
                          TranslatedPort rule[:translated][:port]
                        end

                        if rule[:rule_type] == "DNAT"
                          Protocol rule[:protocol]
                        end

                      }
                    }
                  end
                } if nat_config
              }
            end.to_xml
          end

        end
      end
    end
  end
end
