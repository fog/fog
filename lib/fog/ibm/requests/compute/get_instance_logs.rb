module Fog
  module Compute
    class IBM
      class Real

        # Get an instance's logs
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * logs<~Array>:
        # TODO: docs
        def get_instance_logs(instance_id, start_index=nil)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/instances/#{instance_id}/logs" +
                         (start_index ? "?startIndex=#{start_index}" : '')
          )
        end

      end
    end
  end
end
