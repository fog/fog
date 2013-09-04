module Fog
  module Compute
    class VcloudDirector
      class Real
                
        def post_vm_poweron(vm_id)  
          
          request(
            :expects  => 202,                
            :method   => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/power/action/powerOn"
          )
        end
      end
    end
  end
end
