module Fog
  module Identity
    class OpenStack
      class Real
        def get_service_by_name(name)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "OS-KSADM/services?name=#{name}"
          )
        end
      end

      class Mock
        def get_service_by_name(name)
          response = Excon::Response.new
          response.status = 200
          service = self.data[:services].values.select {|service| service['name'] == name}[0]
          response.body = {
            'service' => service
          }
          response
        end
      end
    end
  end
end
