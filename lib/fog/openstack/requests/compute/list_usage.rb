module Fog
  module Compute
    class OpenStack
      class Real

        def list_usage(date_start, date_end, detailed=false)
          # TODO: Handle nasty date formats
          detailed = (detailed ? "1" : "0")
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "os-simple-tenant-usage?start=#{date_start.iso8601}&end=#{date_end.iso8601}&detailed=#{detailed}"
          )
        end

      end

      class Mock

        # TODO: Mocks to go here

      end
    end
  end
end
