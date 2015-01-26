module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a disk volume from a disk offering. This disk volume must still be attached to a virtual machine to make use of it.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createVolume.html]
        def create_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createVolume')
          else
            options.merge!('command' => 'createVolume',
            'name' => args[0])
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

      class Mock
        def create_volume(options={})
          volume_id = Fog::Cloudstack.uuid

          unless volume_name = options['name']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command createvolume due to missing parameter name')
          end

          unless zone_id = options['zoneid']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command createvolume due to missing parameter zoneid')
          end

          unless disk_offering_id = options['diskofferingid']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command createvolume due to missing parameter diskofferingid')
          end

          volume = {
             "id"                      => volume_id,
             "name"                    => volume_name,
             "zoneid"                  => zone_id,
             "zonename"                => "ey-wdc-00",
             "type"                    => "DATADISK",
             "size"                    => 5368709120,
             "created"                 => "2012-05-22T14:52:55-0500",
             "state"                   => "Allocated",
             "account"                 => "accountname",
             "domainid"                => "6023b6fe-5bef-4358-bc76-9f4e75afa52f",
             "domain"                  => "ROOT",
             "storagetype"             => "shared",
             "hypervisor"              => "None",
             "diskofferingid"          => disk_offering_id,
             "diskofferingname"        => "Small",
             "diskofferingdisplaytext" => "Small Disk, 5 GB",
             "storage"                 => "none",
             "destroyed"               => false,
             "isextractable"           => false
          }

          self.data[:volumes][volume_id]= volume
          {'createvolumeresponse' => volume}
        end
      end
    end
  end
end

