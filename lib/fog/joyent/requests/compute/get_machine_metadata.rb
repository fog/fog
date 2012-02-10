module Fog
  module Compute
    class Joyent
      class Real

        def get_machine_metadata(machine_id, options = {})
          query = {}
          if options[:credentials]
            if options[:credentials].is_a?(Boolean)
              query[:credentials] = options[:credentials]
            else
              raise ArgumentError, "options[:credentials] must be a Boolean or nil"
            end
          end

          request(
            :path => "/my/machines/#{machine_id}/metadata",
            :query => query
          )
        end

      end
    end
  end
end
