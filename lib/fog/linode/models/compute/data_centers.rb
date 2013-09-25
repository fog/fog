require 'fog/core/collection'
require 'fog/linode/models/compute/data_center'

module Fog
  module Compute
    class Linode
      class DataCenters < Fog::Collection
        model Fog::Compute::Linode::DataCenter

        def all
          load datacenters
        end

        private
        def datacenters(id=nil)
          service.avail_datacenters.body['DATA'].map { |datacenter| map_datacenter datacenter }
        end

        def map_datacenter(datacenter)
          datacenter = datacenter.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          datacenter.merge! :id => datacenter[:datacenterid], :name => datacenter[:location]
        end
      end
    end
  end
end
