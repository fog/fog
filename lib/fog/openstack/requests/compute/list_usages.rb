module Fog
  module Compute
    class OpenStack
      class Real

        def list_usages(date_start = nil, date_end = nil, detailed=false)
          params = Hash.new
          params[:start] = date_start.iso8601.gsub(/\+.*/, '') if date_start
          params[:end]   = date_end.iso8601.gsub(/\+.*/, '')   if date_end
          params[:detailed] = (detailed ? '1' : '0')           if detailed

          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'os-simple-tenant-usage',
            :query    => params
          )
        end

      end

      class Mock

        # TODO: Mocks to go here

      end
    end
  end
end
