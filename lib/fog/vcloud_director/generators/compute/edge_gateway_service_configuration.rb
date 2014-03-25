module Fog
  module Generators
    module Compute
      module VcloudDirector
        class EdgeGatewayServiceConfiguration
          def initialize(configuration={})
            @configuration = configuration
          end

          def generate_xml
            Nokogiri::XML::Builder.new do |xml|
              xml.EdgeGatewayServiceConfiguration('xmlns' => "http://www.vmware.com/vcloud/v1.5"){
                build_firewall_service(xml)
                build_nat_service(xml)
                build_load_balancer_service(xml)
              }
            end.to_xml
          end

          private

          def build_load_balancer_service(xml)
            lb_config = @configuration[:LoadBalancerService]
            return unless lb_config

            xml.LoadBalancerService {
              xml.IsEnabled lb_config[:IsEnabled] if lb_config.key?(:IsEnabled)
              lb_config[:Pool].each do |pool|
                xml.Pool {
                  xml.Name pool[:Name]
                  xml.Description pool[:Description] if pool.key?(:Description)
                  pool[:ServicePort].each do |service_port|
                    xml.ServicePort {
                      xml.IsEnabled service_port[:IsEnabled]
                      xml.Protocol service_port[:Protocol]
                      xml.Algorithm service_port[:Algorithm]
                      xml.Port service_port[:Port]
                      xml.HealthCheckPort service_port[:HealthCheckPort]
                      xml.HealthCheck {
                        xml.Mode service_port[:HealthCheck][:Mode]
                        xml.Uri service_port[:HealthCheck][:Uri]
                        xml.HealthThreshold service_port[:HealthCheck][:HealthThreshold]
                        xml.UnhealthThreshold service_port[:HealthCheck][:UnhealthThreshold]
                        xml.Interval service_port[:HealthCheck][:Interval]
                        xml.Timeout service_port[:HealthCheck][:Timeout]
                      }
                    }
                  end
                  pool[:Member].each do |member|
                    xml.Member {
                      xml.IpAddress member[:IpAddress]
                      xml.Weight member[:Weight]
                      member[:ServicePort].each do |member_service_port|
                        xml.ServicePort {
                          xml.Protocol member_service_port[:Protocol]
                          xml.Port member_service_port[:Port]
                          xml.HealthCheckPort member_service_port[:HealthCheckPort]
                        }
                      end
                    }
                  end

                }
              end
              lb_config[:VirtualServer].each do |virtual_server|
                xml.VirtualServer {
                  xml.IsEnabled virtual_server[:IsEnabled]
                  xml.Name virtual_server[:Name]
                  xml.Description virtual_server[:Description]
                  xml.Interface(:href => virtual_server[:Interface][:href], :name => virtual_server[:Interface][:name])
                  xml.IpAddress virtual_server[:IpAddress]
                  virtual_server[:ServiceProfile].each do |service_profile|
                    xml.ServiceProfile {
                      xml.IsEnabled service_profile[:IsEnabled]
                      xml.Protocol service_profile[:Protocol]
                      xml.Port service_profile[:Port]
                      xml.Persistence {
                        xml.Method service_profile[:Persistence][:Method]
                        if service_profile[:Persistence][:Method] == 'COOKIE'
                          xml.CookieName service_profile[:Persistence][:CookieName]
                          xml.CookieMode service_profile[:Persistence][:CookieMode]
                        end
                      }
                    }
                  end
                  xml.Logging virtual_server[:Logging]
                  xml.Pool virtual_server[:Pool]
                }
              end
            }
          end

          def build_nat_service(xml)
            nat_config = @configuration[:NatService]
            return unless nat_config

            xml.NatService {
              xml.IsEnabled nat_config[:IsEnabled]

              nat_config[:NatRule].each do |rule|
                xml.NatRule {
                  xml.RuleType rule[:RuleType]
                  xml.IsEnabled rule[:IsEnabled]
                  xml.Id rule[:Id]
                  gateway_nat_rule = rule[:GatewayNatRule]
                  xml.GatewayNatRule {
                    xml.Interface(:name => gateway_nat_rule[:Interface][:name], :href => gateway_nat_rule[:Interface][:href])
                    xml.OriginalIp gateway_nat_rule[:OriginalIp]
                    xml.OriginalPort gateway_nat_rule[:OriginalPort] if gateway_nat_rule.key?(:OriginalPort)
                    xml.TranslatedIp gateway_nat_rule[:TranslatedIp]
                    xml.TranslatedPort gateway_nat_rule[:TranslatedPort] if gateway_nat_rule.key?(:TranslatedPort)
                    xml.Protocol gateway_nat_rule[:Protocol] if rule[:RuleType] == "DNAT"
                  }
                }
              end
            }
          end

          def build_firewall_service(xml)
            firewall_config = @configuration[:FirewallService]
            return unless firewall_config

            xml.FirewallService {
              xml.IsEnabled firewall_config[:IsEnabled]
              xml.DefaultAction firewall_config[:DefaultAction] if firewall_config.key?(:DefaultAction)
              xml.LogDefaultAction firewall_config[:LogDefaultAction] if firewall_config.key?(:LogDefaultAction)
              firewall_config[:FirewallRule].each do |rule|
                xml.FirewallRule {
                  xml.Id rule[:Id]
                  xml.IsEnabled rule[:IsEnabled] if rule.key?(:IsEnabled)
                  xml.MatchOnTranslate rule[:MatchOnTranslate] if rule.key?(:MatchOnTranslate)
                  xml.Description rule[:Description] if rule.key?(:Description)
                  xml.Policy rule[:Policy] if rule.key?(:Policy)

                  xml.Protocols {
                    rule[:Protocols].each do |key, value|
                      xml.send(key.to_s.capitalize, value)
                    end
                  }
                  xml.IcmpSubType rule[:IcmpSubType] if rule.key?(:IcmpSubType)
                  xml.Port rule[:Port] if rule.key?(:Port)
                  xml.DestinationPortRange rule[:DestinationPortRange]
                  xml.DestinationIp rule[:DestinationIp]
                  xml.SourcePort rule[:SourcePort] if rule.key?(:SourcePort)
                  xml.SourcePortRange rule[:SourcePortRange]
                  xml.SourceIp rule[:SourceIp]
                  xml.Direction rule[:Direction] if rule.key?(:Direction) #Firewall rule direction is allowed only in backward compatibility mode.
                  xml.EnableLogging rule[:EnableLogging] if rule.key?(:EnableLogging)
                }

              end
            }
          end

        end
      end
    end
  end
end
