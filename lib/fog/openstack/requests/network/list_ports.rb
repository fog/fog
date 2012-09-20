module Fog
  module Network
    class OpenStack

      class Real
        def list_ports
          request(
            :expects => 200,
            :method => 'GET',
            :path   => 'ports'
          )
        end
      end

      class Mock
        def list_ports
          Excon::Response.new(
            :body   => { 'ports' => self.data[:ports].values },
            :status => 200
          )
        end
      end

    end
  end
end