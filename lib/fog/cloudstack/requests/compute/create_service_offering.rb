module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createServiceOffering.html]
        def create_service_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createServiceOffering')
          else
            options.merge!('command' => 'createServiceOffering',
            'name' => args[0],
            'displaytext' => args[1])
          end
          request(options)
        end
      end

      class Mock

        def create_service_offering(options={})
          flavour_id = Fog::Cloudstack.uuid

          flavour = {
            "id"            => flavour_id,
            "name"          => "4CPU, 4 GB RAM, High Availability",
            "displaytext"   => "4CPU, 4 GB RAM, High Availability",
            "cpunumber"     => 4,
            "cpuspeed"      => 2000,
            "memory"        => 4096,
            "created"       => Time.now.iso8601,
            "storagetype"   => "shared",
            "offerha"       => true,
            "limitcpuuse"   => false,
            "isvolatile"    => false,
            "issytem"       => false,
            "defaultuse"    => false,
            "iscustomized"  => false,
            "tags"          => []
          }

          self.data[:flavours][flavour_id] = flavour

          {'createserviceofferingresponse' => flavour}
        end
      end

    end
  end
end

