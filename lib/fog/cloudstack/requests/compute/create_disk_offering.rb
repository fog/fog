module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a disk offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createDiskOffering.html]
        def create_disk_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createDiskOffering') 
          else
            options.merge!('command' => 'createDiskOffering', 
            'displaytext' => args[0], 
            'name' => args[1])
          end
          request(options)
        end
      end
 
      class Mock

        def create_disk_offering(options={})
          disk_offering_id = Fog::Cloudstack.uuid

          first_domain_data = data[:domains].first.last
          domain_id = options['domainid'] || first_domain_data['id']
          domain_name = data[:domains][domain_id]['name']

          storage_type = options['storagetype'] || 'shared'
          customized = options['customized'] || false
          disk_size = options['disk_size'] || 1

          disk_offering = {
            "id"           => disk_offering_id,
            "domainid"     => domain_id,
            "domain"       => domain_name,
            "name"         => options['name'],
            "displaytext"  => options['display_text'],
            "disksize"     => disk_size,
            "created"      => Time.now.iso8601,
            "iscustomized" => customized,
            "storagetype"  => storage_type
          }

          self.data[:disk_offerings][disk_offering_id] = disk_offering

          {'creatediskofferingresponse' => disk_offering}
        end
      end 
    end
  end
end

