require 'fog/core/collection'
require 'fog/linode/models/compute/kernel'

module Fog
  module Compute
    class Linode
      class Kernels < Fog::Collection
        model Fog::Compute::Linode::Kernel

        def all
          load kernels
        end

        def all_kvm
          load kernels(:isKVM => 1)
        end

        def all_xen
          load kernels(:isXen => 1)
        end

        def get(id)
          new kernels.select {|kernel| kernel[:id] == id }.first
        end

        private
        def kernels(options={})
          service.avail_kernels(options).body['DATA'].map { |kernel| map_kernel kernel }
        end

        def map_kernel(kernel)
          kernel = kernel.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          kernel.merge! :id => kernel[:kernelid], :name => kernel[:label],
                        :is_xen => kernel[:isxen], :is_kvm => kernel[:iskvm], :is_pvops => kernel[:ispvops]
        end
      end
    end
  end
end
