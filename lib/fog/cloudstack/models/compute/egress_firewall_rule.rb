module Fog
  module Compute
    class Cloudstack
      class EgressFirewallRule < Fog::Model
        identity  :id,                    :aliases => 'id'
        attribute :protocol,              :aliases => 'protocol'
        attribute :network_id,            :aliases => 'networkid'
        attribute :state,                 :aliases => 'state'
        attribute :cidr_list,             :aliases => 'cidrlist'
        attribute :tags,                  :type => :array
        attribute :job_id,                :aliases => 'jobid'   # only on create

        def save
          requires :protocol, :network_id

          options = {
            'protocol'    => protocol,
            'networkid'   => network_id,
            'cidrlist'    => cidr_list,
          }

          response = service.create_egress_firewall_rule(options)
          merge_attributes(response['createegressfirewallruleresponse'])
        end

        def destroy
          requires :id

          response = service.delete_egress_firewall_rule('id' => id )
          success_status = response['deleteegressfirewallruleresponse']['success']

          success_status == 'true'
        end

      end
    end
  end
end
