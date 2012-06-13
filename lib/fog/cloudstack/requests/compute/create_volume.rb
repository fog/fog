module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a volume for an account that already exists.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/createVolume.html]
        def create_volume(options={})
          options.merge!(
            'command' => 'createVolume'
          )

          request(options)
        end

      end # Real

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
