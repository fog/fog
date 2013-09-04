module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_vapp(vapp_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vapp_id}"
          )
        end

      end
    end
  end
end
