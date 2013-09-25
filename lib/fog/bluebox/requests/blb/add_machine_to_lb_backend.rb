module Fog
  module Bluebox
    class BLB
      class Real
        # Add machine to specified lb_backend
        #
        # === Parameters
        # * lb_backend_id<~String> - ID of backend
        # * lb_machine_id<~String> - ID of machine
        # * options<~Hash>:
        #   * port<~Integer> - port machine listens on; defaults to service listening port
        #   * maxconn<~Integer>  - maximum number of connections server can be sent
        #   * backup<~Boolean> - only send traffic to machine if all others are down
        def add_machine_to_lb_backend(lb_backend_id, lb_machine_id, options = {})
          # convert to CGI array args
          body = Hash[options.map {|k,v| ["lb_options[#{k}]", v] }]
          body['lb_machine'] = lb_machine_id
          request(
            :expects => 200,
            :method  => 'POST',
            :path    => "/api/lb_backends/#{lb_backend_id}/lb_machines.json",
            :body    => body.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}"}.join('&')
          )
        end
      end

      class Mock
      end
    end
  end
end
