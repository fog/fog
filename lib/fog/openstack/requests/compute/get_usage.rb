module Fog
  module Compute
    class OpenStack
      class Real

        def get_usage(tenant_id, date_start, date_end)
          # TODO: Handle nasty date formats
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "os-simple-tenant-usage/#{tenant_id}?start=#{date_start.iso8601}&end=#{date_end.iso8601}"
          )
        end

      end

      class Mock

        # TODO: Mocks to go here

      end
    end
  end
end
