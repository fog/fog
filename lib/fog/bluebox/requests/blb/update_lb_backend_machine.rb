module Fog
  module Bluebox
    class BLB
      class Real
        # change machine attributes (port &c) in a single backend
        #
        # === Parameters
        # * lb_backend_id<~String> - ID of backend
        # * lb_machine_id<~String> - ID of machine
        # * options<~Hash>:
        #   * port<~Integer> - port machine listens on
        #   * maxconn<~Integer>  - maximum number of connections server can be sent
        #   * backup<~Boolean> - only send traffic to machine if all others are down
        def update_lb_backend_machine(lb_backend_id, lb_machine_id, options = {})
          # inconsistent, no?
          request(
            :expects => 202,
            :method  => 'PUT',
            :path    => "/api/lb_backends/#{lb_backend_id}/lb_machines/#{lb_machine_id}",
            :body    => options.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}"}.join('&')
          )
        end
      end

      class Mock
      end
    end
  end
end
