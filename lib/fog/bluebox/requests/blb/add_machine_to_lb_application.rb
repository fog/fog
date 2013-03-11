module Fog
  module Bluebox
    class BLB
      class Real
        # Add machine to default lb_backend for each lb_service
        # in the application.
        #
        # === Parameters
        # * lb_application_id<~String> - ID of application
        # * lb_machine_id<~String> - ID of machine
        # * options<~Hash>:
        #   * port<~Integer> - port machine listens on; defaults to service listening port
        #   * maxconn<~Integer>  - maximum number of connections server can be sent
        #   * backup<~Boolean> - only send traffic to machine if all others are down
        #
        def add_machine_to_lb_application(lb_application_id, lb_machine_id, options = {})
          # convert to CGI array args
          body = Hash[options.map {|k,v| ["lb_options[#{k}]", v] }]
          body['lb_machine'] = lb_machine_id
          request(
            :expects => 200,
            :method  => 'POST',
            :path    => "/api/lb_applications/add_machine/#{lb_application_id}.json",
            :body    => body.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v.to_s)}"}.join('&')
          )
        end
      end

      class Mock
      end
    end
  end
end
