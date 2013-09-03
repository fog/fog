module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_vdc(vdc_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "vdc/#{vdc_id}"
          )
        end
        

      end
      
    end
  end
end