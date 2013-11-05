module Fog
  module Compute
    class VcloudDirector
      class Real
        # Get EdgeGateway Identified By ID for this Org vDC.
        #
        # @param [String] id Object identifier of the vDC.
        
          def get_org_vdc_gateway(id)
            response = request(
              :expects    => 200,
              :idempotent => true,
              :method     => 'GET',
              :parser     => Fog::ToHashDocument.new,
              :path       => "admin/edgeGateway/#{id}"
            )
            response
          end
        end

     
      end
  end
end
