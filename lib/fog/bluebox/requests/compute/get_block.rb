module Fog
  module Compute
    class Bluebox
      class Real
        # Get details of a block.
        #
        # ==== Parameters
        # * block_id<~Integer> - Id of block to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO
        def get_block(block_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "api/blocks/#{block_id}.json"
          )
        end
      end
    end
  end
end
