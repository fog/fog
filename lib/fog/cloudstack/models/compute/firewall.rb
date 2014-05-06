module Fog
  module Compute
    class Cloudstack
      class Firewall < Fog::Model
        identity  :id,                                            :aliases => 'id'
        attribute :ip_address_id,                                 :aliases => 'ipaddressid'
        attribute :protocol,                                      :aliases => 'protocol'
        attribute :cidr_list,                                     :aliases => 'cidrlist'
        attribute :start_port,                                    :aliases => 'startport'
        attribute :end_port,                                      :aliases => 'endport'
        attribute :icmp_type,                                     :aliases => 'icmptype'
        attribute :icmp_code,                                     :aliases => 'icmpcode'

        def create_firewall_rule
          requires :ip_address_id, :protocol, :cidr_list

          options = {
              'ipaddressid'        => ip_address_id,
              'protocol'           => protocol,
              'cidrlist'           => cidr_list,
          }
          options.merge!('startport' => start_port) if start_port
          options.merge!('endport' => end_port) if end_port
          options.merge!('icmptype' => icmp_type) if icmp_type
          options.merge!('icmpcode' => icmp_code) if icmp_code

          data = service.create_firewall_rule(options)
          service.jobs.new(data["createfirewallruleresponse"])
        end


      end # Firewall
    end # Cloudstack
  end # Compute
end # Fog