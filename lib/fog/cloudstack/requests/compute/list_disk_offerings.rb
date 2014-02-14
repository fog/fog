  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists all available disk offerings.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listDiskOfferings.html]
          def list_disk_offerings(options={})
            options.merge!(
              'command' => 'listDiskOfferings'
            )
            request(options)
          end
           
        end # Real

        class Mock
          # TODO: add id, name filters and paging params
          def list_disk_offerings(options={})
            disk_offerings = self.data[:disk_offerings]
            { "listdiskofferingsresponse" => { "count"=> disk_offerings.count, "diskoffering"=> disk_offerings.values } }
          end

        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
