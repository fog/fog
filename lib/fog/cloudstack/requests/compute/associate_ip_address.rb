module Fog
  module Compute
    class Cloudstack

      class Real
        # Acquires and associates a public IP to an account.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/associateIpAddress.html]
        def associate_ip_address(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'associateIpAddress')
          else
            options.merge!('command' => 'associateIpAddress')
          end
          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil
          request(options)
        end
      end

      class Mock
        def associate_ip_address(*args)
          public_ip_address_id = Fog::Cloudstack.uuid
          public_ip_address = {
            "id"                => public_ip_address_id,
            "ipaddress"         => "192.168.200.3",
            "allocated"         => "2014-12-22T22:32:39+0000",
            "zoneid"            => "0e276270-7950-4483-bf21-3dc897dbe08a",
            "zonename"          => "Toronto",
            "issourcenat"       => false,
            "projectid"         => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
            "project"           => "TestProject",
            "domainid"          => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
            "domain"            => "TestDomain",
            "forvirtualnetwork" => true,
            "isstaticnat"       => false,
            "issystem"          => false,
            "associatednetworkid" => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
            "associatednetworkname" => "TestNetwork",
            "networkid"         => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
            "state"             => "Allocated",
            "physicalnetworkid" => "f1f1f1f1-f1f1-f1f1-f1f1-f1f1f1f1f1",
            "tags"              => []

          }
          self.data[:public_ip_addresses][public_ip_address_id]= public_ip_address
          {'associateipaddressresponse' => public_ip_address}
        end
      end
    end
  end
end

