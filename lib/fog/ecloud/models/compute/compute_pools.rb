require 'fog/ecloud/models/compute/compute_pool'

module Fog
  module Compute
    class Ecloud
      class ComputePools < Fog::Ecloud::Collection

        undef_method :create

        attribute :href, :aliases => :Href

        model Fog::Compute::Ecloud::ComputePool

        #get_request :get_compute_pool
        #vcloud_type "application/vnd.tmrk.ecloud.publicIp+xml"
        #all_request lambda { |compute_pools| public_ips.connection.get_public_ips(public_ips.href) }

        def all
          check_href!(:message => "the Compute Pool href of the Vdc you want to enumerate")
          if data = connection.get_compute_pools(href).body[:ComputePool]
            load(data)
          end
        end

        def get(uri)
          if data = connection.get_compute_pool(uri)
            new(data.body)
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end
    end
  end
end
