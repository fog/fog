module Fog
  module Generators
    module Compute
      module VcloudDirector
        class EdgeGateway
          def initialize(configuration={})
            @configuration = configuration
          end

          def generate_xml
            Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
              xml.EdgeGatewayServiceConfiguration('xmlns' => "http://www.vmware.com/vcloud/v1.5"){
                build_firewall_service(xml)
                build_nat_service(xml)
                build_load_balancer_service(xml)
              }
            end.to_xml
          end

          private

          def build_load_balancer_service(xml)
            lb_config = @configuration[:load_balancer_service]
            return unless lb_config

            xml.LoadBalancerService {
              xml.IsEnabled lb_config[:is_enabled] if lb_config[:is_enabled]
              lb_config[:pools].each do |pool|
                xml.Pool {
                  xml.Name pool[:name]

                  pool[:service_ports].each do |service_port|
                    xml.ServicePort {
                      xml.IsEnabled service_port[:is_enabled]
                      xml.Protocol service_port[:protocol]
                      xml.Algorithm service_port[:algorithm]
                      xml.Port service_port[:port]
                      xml.HealthCheckPort service_port[:health_check_port]
                      xml.HealthCheck {
                        xml.Mode service_port[:health_check][:mode] #tcp, http, ssl
                        xml.HealthThreshold service_port[:health_check][:health_threshold]
                        xml.UnhealthThreshold service_port[:health_check][:unhealth_threshold]
                        xml.Interval service_port[:health_check][:interval]
                        xml.Timeout service_port[:health_check][:timeout]
                      }
                    }
                  end

                  pool[:members].each do |member|
                    xml.Member {
                      xml.IpAddress member[:ip_address]
                      xml.Weight member[:weight]
                      member[:service_ports].each do |member_service_port|
                        xml.ServicePort {
                          xml.Protocol member_service_port[:protocol]
                          xml.Port member_service_port[:port]
                          xml.HealthCheckPort member_service_port[:health_check_port]
                        }
                      end
                    }
                  end

                }
              end
              lb_config[:virtual_servers].each do |virtual_server|
                xml.VirtualServer {
                  xml.IsEnabled virtual_server[:is_enabled]
                  xml.Name virtual_server[:name]
                  xml.Description virtual_server[:description]
                  xml.Interface(:href => virtual_server[:interface][:href], :name => virtual_server[:interface][:name])
                  xml.IpAddress virtual_server[:ip_address]
                  virtual_server[:service_profiles].each do |service_profile|
                    xml.ServiceProfile {
                      xml.IsEnabled service_profile[:is_enabled]
                      xml.Protocol service_profile[:protocol]
                      xml.Port service_profile[:port]
                      xml.Persistence {
                        xml.Method service_profile[:persistence][:method]
                        if service_profile[:persistence][:method] == 'COOKIE'
                          xml.CookieName service_profile[:persistence][:cookie_name]
                          xml.CookieMode service_profile[:persistence][:cookie_mode]
                        end
                      }
                    }
                  end
                  xml.Logging virtual_server[:logging]
                  xml.Pool virtual_server[:pool]
                }
              end
            }
          end

          def build_nat_service(xml)
            nat_config = @configuration[:nat_service]
            return unless nat_config

            xml.NatService {
              xml.IsEnabled nat_config[:is_enabled]

              nat_config[:rules].each do |rule|
                xml.NatRule {
                  xml.RuleType rule[:rule_type]
                  xml.IsEnabled rule[:is_enabled]
                  xml.Id rule[:id]
                  xml.GatewayNatRule {
                    xml.Interface(:name => rule[:interface][:name], :href => rule[:interface][:href])
                    xml.OriginalIp rule[:original][:ip]
                    xml.OriginalPort rule[:original][:port] if rule[:original][:port]
                    xml.TranslatedIp rule[:translated][:ip]
                    xml.TranslatedPort rule[:translated][:port] if rule[:translated][:port]
                    xml.Protocol rule[:protocol] if rule[:rule_type] == "DNAT"
                  }
                }
              end
            }
          end

          def build_firewall_service(xml)
            firewall_config = @configuration[:firewall_service]
            return unless firewall_config

            xml.FirewallService {
              xml.IsEnabled 'true'
              xml.DefaultAction firewall_config[:default_action] if firewall_config[:default_action]
              xml.LogDefaultAction firewall_config[:log_default_action] if firewall_config[:log_default_action]
              firewall_config[:rules].each do |rule|
                xml.FirewallRule {
                  xml.Id rule[:id]
                  xml.IsEnabled rule[:is_enabled] if rule[:is_enabled]
                  xml.MatchOnTranslate rule[:match_on_translate] if rule[:match_on_translate]
                  xml.Description rule[:description]
                  xml.Policy rule[:policy]

                  xml.Protocols {
                    rule[:protocols].each do |protocol|
                      xml.send(protocol.to_s.capitalize, true)
                    end
                  }
                  xml.IcmpSubType "any" if rule[:protocols].include? :icmp
                  xml.Port rule[:destination][:port] == "Any" ? "-1" : rule[:destination][:port]
                  xml.DestinationPortRange rule[:destination][:port]
                  xml.DestinationIp rule[:destination][:ip]
                  xml.SourcePort rule[:source][:port] == "Any" ? "-1" : rule[:source][:port]
                  xml.SourcePortRange rule[:source][:port]
                  xml.SourceIp rule[:source][:ip]
                }

              end
            }
          end


        end
      end
    end
  end
end
