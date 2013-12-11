module Fog
  module AWS
    class ELB
      class Real

        require 'fog/aws/parsers/elb/empty'


        # Sets attributes of the load balancer
        #
        # Currently the only attribute that can be set is whether CrossZoneLoadBalancing
        # is enabled
        #
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_ModifyLoadBalancerAttributes.html
        # ==== Parameters
        # * lb_name<~String> - Name of the ELB
        # * options<~Hash>
        #   * 'CrossZoneLoadBalancing'<~Hash>:
        #     * 'Enabled'<~Boolean> whether to enable cross zone load balancing
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def modify_load_balancer_attributes(lb_name, options)
          attributes = Fog::AWS.serialize_keys 'LoadBalancerAttributes', options
          request(attributes.merge(
            'Action'           => 'ModifyLoadBalancerAttributes',
            'LoadBalancerName' => lb_name,
            :parser            => Fog::Parsers::AWS::ELB::Empty.new
          ))
        end

      end

      class Mock
        def modify_load_balancer_attributes(lb_name, attributes)
          raise Fog::AWS::ELB::NotFound unless load_balancer = self.data[:load_balancers][lb_name]

          if attributes['CrossZoneLoadBalancing']
            load_balancer['LoadBalancerAttributes'].merge! attributes
          end
          
          response = Excon::Response.new

          response.status = 200
          response.body = {
            "ResponseMetadata" => {
              "RequestId" => Fog::AWS::Mock.request_id
            }
          }

          response
        end
      end
    end
  end
end
