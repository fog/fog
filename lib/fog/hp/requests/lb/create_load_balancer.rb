module Fog
  module HP
    class LB
      class Real
        def create_load_balancer(name, nodes, options={})
          #required
          # name
          #at least one node
          data = {
            "name"  => name,
            "nodes" => nodes
          }

          if options['port']
            data['port'] = options['port']
          end

          if options['protocol']
            data['protocol'] = options['protocol']
          end

          if options['virtualIps']
            data['virtualIps'] = []
            for vip in options['virtualIps']
              data['virtualIps'] << vip
            end
          end

          response = request(
            :body    => Fog::JSON.encode(data),
            :expects => 200,
            :method  => 'POST',
            :path    => "loadbalancers/#{load_balancer_id}"
          )
          response

        end
      end
      class Mock
        def create_load_balancer(name, nodes, options={})
          response = Excon::Response.new


          response
        end
      end
    end
  end
end