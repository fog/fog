require 'fog/core/collection'
require 'fog/compute/models/linode/data_center'

module Fog
  module Linode
    class Compute
      class DataCenters < Fog::Collection
        model Fog::Linode::Compute::DataCenter

        def all
          load datacenters
        end

        private
        def datacenters(id=nil)
          connection.avail_datacenters.body['DATA'].map { |datacenter| map_datacenter datacenter }
        end
        
        def map_datacenter(datacenter)
          datacenter = datacenter.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          datacenter.merge! :id => datacenter[:datacenterid], :name => datacenter[:location]
        end
      end
    end
  end
end
