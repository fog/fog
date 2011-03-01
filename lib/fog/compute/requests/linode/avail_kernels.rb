module Fog
  module Linode
    class Compute
      class Real
        def avail_kernels(kernel_id=nil)
          options = {}
          if kernel_id
            options.merge!(:kernelId => kernel_id)
          end          
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.kernels' }.merge!(options)
          )
        end
      end
    end
  end
end
