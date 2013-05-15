module Fog
  module Compute
    class Vsphere
      class Real
        def get_datastore(name, datacenter_name)
          datastore = get_raw_datastore(name, datacenter_name)
          raise(Fog::Compute::Vsphere::NotFound) unless datastore
          datastore_attributes(datastore, datacenter_name)
        end

        protected

        def get_raw_datastore(name, datacenter_name)
          dc = find_raw_datacenter(datacenter_name)

          @connection.serviceContent.viewManager.CreateContainerView({
            :container  => dc.datastoreFolder,
            :type       =>  ["Datastore"],
            :recursive  => true
          }).view.select{|ds| ds.name == name}.first
        end
      end

      class Mock
        def get_datastore(name, datacenter_name)
        end
      end
    end
  end
end
