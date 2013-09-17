module Fog
  module Compute
    class VcloudDirector
      class Real
        def get_edge_gateways(vdc_id)
          request(
              :expects  => 200,
              :method   => 'GET',
              :parser   => Fog::ToHashDocument.new,
              :path     => "admin/vdc/#{vdc_id}/edgeGateways"
          )
        end
      end
    end
  end
end
