module Fog
  module Compute
    class VcloudDirector
      class Real

        def delete_vapp(vapp_id)

          request(
            :expects  => 202,
            :method   => 'DELETE',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vapp_id}"
          )
        end

      end
    end
  end
end

