module Fog
  module Compute
    class Vsphere
      class Real
        def get_datacenter name
          dc = find_raw_datacenter(name)
          raise(Fog::Compute::Vsphere::NotFound) unless dc
          {:name => dc.name, :status => dc.overallStatus}
        end

        protected

        def find_raw_datacenter name
          raw_datacenters.find {|d| d.name == name} ||  get_raw_datacenter(name)
        end

        def get_raw_datacenter name
          @connection.serviceInstance.find_datacenter(name)
        end
      end

      class Mock
        def get_datacenter name
          {:name => "Solutions", :status => "grey"}
        end
      end
    end
  end
end
