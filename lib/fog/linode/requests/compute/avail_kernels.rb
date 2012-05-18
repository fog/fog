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

      class Mock
        def avail_kernels(kernel_id=nil)
          response = Excon::Response.new
          response.status = 200

          body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.kernels"
          }
          if kernel_id
            mock_kernel = create_mock_kernel(kernel_id)
            response.body = body.merge("DATA" => [mock_kernel])
          else
            mock_kernels = []
            10.times do
              kernel_id = rand(1..200)
              mock_kernels << create_mock_kernel(kernel_id)
            end
            response.body = body.merge("DATA" => mock_kernels)
          end
          response
        end

        private

        def create_mock_kernel(kernel_id)
          {
            "ISPVOPS"  => 1,
            "ISXEN"    => 1,
            "KERNELID" => kernel_id,
            "LABEL"    => "Latest 3.0 (3.0.18-linode43)"
          }
        end
      end
    end
  end
end
