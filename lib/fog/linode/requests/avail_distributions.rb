module Fog
  module Linode
    class Real

      # Get available distributions
      #
      # ==== Parameters
      # * options<~Hash>:
      #   * distributionId<~Integer>: id to limit results to
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      # TODO: docs
      def avail_distributions(options={})
        request(
          :expects  => 200,
          :method   => 'GET',
          :query    => { :api_action => 'avail.distributions' }.merge!(options)
        )
      end

    end

    class Mock

      def avail_distributions(distribution_id)
        Fog::Mock.not_implemented
      end

    end
  end
end
