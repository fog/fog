require 'fog/core/collection'

module Fog
  module Bluebox
    class BLB
      class Applications < Fog::Collection

        def all
          data = service.get_blocks.body
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:key_data => [server.private_key])
          server
        end

        def get(server_id)
          if server_id && server = service.get_block(server_id).body
            new(server)
          end
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end

      end

    end
  end
end
