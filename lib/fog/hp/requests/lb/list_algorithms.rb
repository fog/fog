module Fog
  module HP
    class LB
      # List algorithms
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'algorithms'<~Array>:
      #       * 'name'<~String> - Name of the algorithm
      class Real
        def list_algorithms
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'algorithms'
          )
        end
      end
      class Mock
        def list_algorithms
          response = Excon::Response.new
          algorithms  = self.data[:algorithms].values
          response.status = 200
          response.body = { 'algorithms' => algorithms }
          response
        end
      end
    end
  end
end
