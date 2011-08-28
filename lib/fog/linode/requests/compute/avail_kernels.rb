module Fog
  module Compute
    class Linode
      class Real

        # Get available kernels
        #
        # ==== Parameters
        # * kernelId<~Integer>: id to limit results to
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
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
