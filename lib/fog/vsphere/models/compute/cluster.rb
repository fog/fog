module Fog
  module Compute
    class Vsphere
      class Cluster < Fog::Model
        identity :id

        attribute :name
        attribute :datacenter
        attribute :num_host
        attribute :num_cpu_cores
        attribute :overall_status
        attribute :full_path

        def resource_pools(filters = { })
          self.attributes[:resource_pools] ||= id.nil? ? [] : service.resource_pools({
                                                                                          :service => service,
                                                                                          :cluster    => name,
                                                                                          :datacenter => datacenter
                                                                                        }.merge(filters))
        end

        def to_s
          name
        end
      end
    end
  end
end
