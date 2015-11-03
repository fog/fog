require 'fog/core/collection'
require 'fog/linode/models/compute/kernel'

module Fog
  module Compute
    class Linode
      class Kernels < Fog::Collection
        model Fog::Compute::Linode::Kernel

        # Returns an Array of the available kernels.
        #
        # The list of kernels can be filtered by support for KVM or Xen by
        # specifying kvm: true or xen: true respectively as options.
        def all(options={})
          [[:kvm, :isKVM], [:xen, :isXen]].each do |type, param|
            options[param] = options[type] ? 1 : 0 if options.has_key?(type)
          end
          load kernels(options)
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
