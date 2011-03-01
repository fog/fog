module Fog
  module Linode
    class Compute
      class Real
        def linode_create(datacenter_id, plan_id, payment_term)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action   => 'linode.create',
              :datacenterId => datacenter_id,
              :paymentTerm  => payment_term,
              :planId       => plan_id
            }
          )
        end
      end
    end
  end
end
