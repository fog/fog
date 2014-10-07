module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an instant snapshot of a volume.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createSnapshot.html]
        def create_snapshot(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createSnapshot') 
          else
            options.merge!('command' => 'createSnapshot', 
            'volumeid' => args[0])
          end
          request(options)
        end
      end
 
      class Mock
        def create_snapshot(options={})
          snapshot_id = Fog::Cloudstack.uuid

          unless volume_id = options['volumeid']
            raise Fog::Compute::Cloudstack::BadRequest.new('Unable to execute API command createsnapshot due to missing parameter volumeid')
          end

          snapshot = {
             "id"                      => snapshot_id,
             "name"                    => "ROOT-6",
             "created"                 => "2013-05-22T14:52:55-0500",
             "state"                   => "BackedUp",
             "account"                 => "accountname",
             "domainid"                => "6023b6fe-5bef-4358-bc76-9f4e75afa52f",
             "domain"                  => "ROOT",
             "intervaltype"            => "weekly"
          }

          self.data[:snapshots][snapshot_id]= snapshot
          {'createsnapshotresponse' => snapshot}
        end
      end 
    end
  end
end

