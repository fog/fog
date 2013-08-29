module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_vapp_template(vapp_template_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "vAppTemplate/#{vapp_template_id}"
          )
        end
        
      end
    end
  end
end
