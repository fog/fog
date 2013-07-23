module Fog
  module Compute
    class Vsphere
      class Real
        def get_compute_resource(name, datacenter_name)
          compute_resource = get_raw_compute_resource(name, datacenter_name)
          raise(Fog::Compute::Vsphere::NotFound) unless compute_resource
          compute_resource_attributes(compute_resource, datacenter_name)
        end

        protected

        def get_raw_compute_resource(name, datacenter_name)
          find_raw_datacenter(datacenter_name).find_compute_resource(name)
        end
      end

      class Mock
        def get_compute_resource(name, datacenter_name)
        end
      end
    end
  end
end
