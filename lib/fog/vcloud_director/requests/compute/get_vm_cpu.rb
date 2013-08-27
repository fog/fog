module Fog
  module Compute
    class VcloudDirector
      class Real
        
        def get_vm_cpu(vm_id)
          request(
            :expects  => 200,
            :headers  => { 'Accept' => 'application/*+xml;version=1.5' },
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "vApp/#{vm_id}/virtualHardwareSection/cpu"
          )
        end

      end
    end
  end
end
