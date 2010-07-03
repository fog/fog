module Fog
  module Linode
    class Real

      # Get available plans
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      # TODO: docs
      def avail_linodeplans
        request(
          :expects  => 200,
          :method   => 'GET',
          :query    => { :api_action => 'avail.linodeplans' }
        )
      end

    end

    class Mock

      def avail_linodeplans
        Fog::Mock.not_implemented
      end

    end
  end
end
