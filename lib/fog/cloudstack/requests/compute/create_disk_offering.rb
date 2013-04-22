module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a disk offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createDiskOffering.html]
        def create_disk_offering(options={})
          options.merge!(
            'command' => 'createDiskOffering'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
