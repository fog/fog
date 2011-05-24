require 'fog/core/collection'
require 'fog/compute/models/linode/kernel'

module Fog
  module Linode
    class Compute
      class Kernels < Fog::Collection
        model Fog::Linode::Compute::Kernel

        def all
          load kernels
        end

        def get(id)
          new kernels(id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end

        private
        def kernels(id=nil)
          connection.avail_kernels(id).body['DATA'].map { |kernel| map_kernel kernel }
        end
        
        def map_kernel(kernel)
          kernel = kernel.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          kernel.merge! :id => kernel[:kernelid], :name => kernel[:label]
        end
      end
    end
  end
end
