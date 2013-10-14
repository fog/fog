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
            lb_config = @configuration[:load_balancer_service]
            Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
              EdgeGatewayServiceConfiguration(
                  'xmlns' => "http://www.vmware.com/vcloud/v1.5",
                  'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                  'xsi:schemaLocation' => "http://www.vmware.com/vcloud/v1.5 http://vendor-api-url.net/v1.5/schema/master.xsd"
              ) {
                FirewallService {
                  IsEnabled 'true'
                  DefaultAction firewall_config[:default_action] if firewall_config[:default_action]
                  LogDefaultAction firewall_config[:log_default_action] if firewall_config[:log_default_action]
                  firewall_config[:rules].each do |rule|
                    FirewallRule {
                      Id rule[:id]
                      IsEnabled rule[:is_enabled] if rule[:is_enabled]
                      MatchOnTranslate rule[:match_on_translate] if rule[:match_on_translate]
                      Description rule[:description]
                      Policy rule[:policy]

                      Protocols {
                        rule[:protocols].each do |protocol|
                          send(protocol.to_s.capitalize, true)
                        end
                      }
                      IcmpSubType "any" if rule[:protocols].include? :icmp
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
                        Interface(:name => rule[:interface][:name], :href => rule[:interface][:href])
                        OriginalIp rule[:original][:ip]
                        OriginalPort rule[:original][:port] if rule[:original][:port]
                        TranslatedIp rule[:translated][:ip]
                        TranslatedPort rule[:translated][:port] if rule[:translated][:port]
                        Protocol rule[:protocol] if rule[:rule_type] == "DNAT"
                      }
                    }
                  end
                } if nat_config

                LoadBalancerService {
                  IsEnabled lb_config[:is_enabled] if lb_config[:is_enabled]
                  lb_config[:pools].each do |pool|
                    Pool {
                      Name pool[:name]

                      pool[:service_ports].each do |service_port|
                        ServicePort {
                          IsEnabled service_port[:is_enabled]
                          Protocol service_port[:protocol]
                          Algorithm service_port[:algorithm]
                          Port service_port[:port]
                          HealthCheckPort service_port[:health_check_port]
                          HealthCheck {
                            Mode service_port[:health_check][:mode]  #tcp, http, ssl
                            HealthThreshold service_port[:health_check][:health_threshold]
                            UnhealthThreshold service_port[:health_check][:unhealth_threshold]
                            Interval service_port[:health_check][:interval]
                            Timeout service_port[:health_check][:timeout]
                          }
                        }
                      end

                      pool[:members].each do |member|
                        Member {
                          IpAddress member[:ip_address]
                          Weight member[:weight]
                          member[:service_ports].each do |member_service_port|
                          ServicePort {
                            Protocol member_service_port[:protocol]
                            Port member_service_port[:port]
                            HealthCheckPort member_service_port[:health_check_port]
                          }
                          end
                        }
                      end

                    }
                  end
                  lb_config[:virtual_servers].each do |virtual_server|
                    VirtualServer {
                      IsEnabled virtual_server[:is_enabled]
                      Name virtual_server[:name]
                      Description virtual_server[:description]
                      Interface(:href => virtual_server[:interface][:href], :name => virtual_server[:interface][:name] )
                      IpAddress virtual_server[:ip_address]
                      virtual_server[:service_profiles].each do |service_profile|
                        ServiceProfile {
                          IsEnabled service_profile[:is_enabled]
                          Protocol service_profile[:protocol]
                          Port service_profile[:port]
                          Persistence {
                            Method service_profile[:persistence][:method]
                            if service_profile[:persistence][:method] == 'COOKIE'
                              CookieName service_profile[:persistence][:cookie_name]
                              CookieMode service_profile[:persistence][:cookie_mode]
                            end
                          }
                        }
                      end
                      Logging virtual_server[:logging]
                      Pool  virtual_server[:pool]
                    }
                  end
                } if lb_config

              }
            end.to_xml
          end


        end
      end
    end
  end
end
