module Fog
  module Compute
    class VcloudDirector
      class Real

        def build_xml configuration
          Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do
            EdgeGatewayServiceConfiguration('xmlns' => "http://www.vmware.com/vcloud/v1.5",
                                            'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
                                            'xsi:schemaLocation' => "http://www.vmware.com/vcloud/v1.5 http://vendor-api-url.net/v1.5/schema/master.xsd") {
              firewall_config = configuration[:firewall_service]
              FirewallService {
                #IsEnabled firewall_config[:is_enabled]
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
              }
            }
          end.to_xml
        end

        def post_configure_edge_gateway(id, configuration)
          body = build_xml(configuration)
          request(
              :body => body,
              :expects => 202,
              :headers => {'Content-Type' => 'application/vnd.vmware.admin.edgeGatewayServiceConfiguration+xml'},
              :method => 'POST',
              :parser => Fog::ToHashDocument.new,
              :path => "admin/edgeGateway/#{id}/action/configureServices"
          )
        end


      end
    end
  end
end

