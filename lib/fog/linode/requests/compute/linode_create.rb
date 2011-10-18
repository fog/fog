module Fog
  module Compute
    class Linode
      class Real

        # Creates a linode and assigns you full privileges
        #
        # ==== Parameters 	
        # * datacenter_id<~Integer>: id of datacenter to place new linode in
        # * plan_id<~Integer>: id of plan to boot new linode with        
        # * payment_term<~Integer>: Subscription term in months, in [1, 12, 24]
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
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
