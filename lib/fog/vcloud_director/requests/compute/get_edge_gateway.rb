module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_edge_gateway(id)

          request({
                      :expects  => 200,
                      :method   => 'GET',
                      :parser   => Fog::ToHashDocument.new,
                      :path     => "admin/edgeGateway/#{id}"
                  })
        end

      end
    end
  end
end
