module Fog
  module HP
    class LB
      # Update an existing load balancer
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of the load balancer to update
      # * options<~Hash>:
      #   * 'name'<~String> - Name for the load balancer
      #   * 'algorithm'<~String> - Algorithm for the load balancer
      class Real
        def update_load_balancer(load_balancer_id, options={})
          data = {}
          l_options = ['name', 'algorithm']
          l_options.select{|o| options[o]}.each do |key|
            data[key] = options[key]
          end

          request(
            :body    => Fog::JSON.encode(data),
            :expects => 202,
            :method  => 'PUT',
            :path    => "loadbalancers/#{load_balancer_id}"
          )
        end
      end
      class Mock
        def update_load_balancer(load_balancer_id, options={})
          response = Excon::Response.new
          if lb = list_load_balancers.body['loadBalancers'].find { |_| _['id'] == load_balancer_id }

            lb['name']      = options['name']      if options['name']
            lb['algorithm'] = options['algorithm'] if options['algorithm']

            response.status = 202
            response.body   = ''
            response
          else
            raise Fog::HP::LB::NotFound
          end
        end
      end
    end
  end
end
