module Fog
  module HP
    class LB
      # List protocols
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'protocols'<~Array>:
      #       * 'name'<~String> - Name of the protocol
      #       * 'port'<~String> - Port of the protocol
      class Real
        def list_protocols
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'protocols'
          )
          response
        end
      end
      class Mock
        def list_protocols
          response = Excon::Response.new
          protocols  = self.data[:protocols].values
          response.status = 200
          response.body   = { 'protocols' => protocols }
          response
        end
      end
    end
  end
end
