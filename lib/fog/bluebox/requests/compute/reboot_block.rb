module Fog
  module Compute
    class Bluebox
      class Real

        # Reboot block
        #
        # ==== Parameters
        # * block_id<~String> - Id of block to reboot
        # * type<~String> - Type of reboot, must be in ['HARD', 'SOFT']
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO
        def reboot_block(block_id, type = 'SOFT')
          request(
            :expects  => 200,
            :method   => 'PUT',
            :path     => "api/blocks/#{block_id}/#{'soft_' if type == 'SOFT'}reboot.json"
          )
        end

      end
    end
  end
end
