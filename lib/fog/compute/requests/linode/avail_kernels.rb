module Fog
  module Linode
    class Compute
      class Real
        def avail_kernels(options={})
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
