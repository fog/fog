module Fog
  module Compute
    class VcloudDirector
      class Real

        def post_vm_poweroff(vm_id)

          request(
            :expects  => 202,
            :method   => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/power/action/powerOff"
          )
        end
      end
    end
  end
end
