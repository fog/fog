module Fog
  module Compute
    class Linode
      class Real
        # Get available kernels
        #
        # ==== Parameters
        # * options<~Hash>
        #   * isXen<~Boolean> Show or hide Xen compatible kernels
        #   * isKVM<~Boolean> Show or hide KVM compatible kernels
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO: docs
        def avail_kernels(options={})
          # avail.kernels used to accept a kernelId parameter (now removed)
          raise Fog::Errors::Error.new('avail_kernels no longer accepts a kernelId parameter') unless !options || options.is_a?(Hash)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.kernels' }.merge!(options || {})
          )
        end
      end

      class Mock
        def avail_kernels(options={})
          # avail.kernels used to accept a kernelId parameter (now removed)
          raise Fog::Errors::Error.new('avail_kernels no longer accepts a kernelId parameter') unless !options || options.is_a?(Hash)

          response = Excon::Response.new
          response.status = 200

          body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.kernels"
          }
          mock_kernels = []
          10.times do
            kernel_id = rand(1..200)
            mock_kernels << create_mock_kernel(kernel_id)
          end
          response.body = body.merge("DATA" => mock_kernels)
          response
        end

        private

        def create_mock_kernel(kernel_id)
          {
            "ISPVOPS"  => 1,
            "ISXEN"    => 1,
            "ISKVM"    => 1,
            "KERNELID" => kernel_id,
            "LABEL"    => "Latest 3.0 (3.0.18-linode43)"
          }
        end
      end
    end
  end
end
