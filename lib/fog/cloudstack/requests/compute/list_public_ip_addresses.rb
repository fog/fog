module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all public ip addresses
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listPublicIpAddresses.html]
        def list_public_ip_addresses(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listPublicIpAddresses')
          else
            options.merge!('command' => 'listPublicIpAddresses')
          end

          # add project id if we have one
          @cloudstack_project_id ? options.merge!('projectid' => @cloudstack_project_id) : nil

          request(options)
        end
      end

      class Mock
        def list_public_ip_addresses(*arg)
          public_ip_addresses = self.data[:public_ip_addresses]
          { "listpublicipaddressesresponse" => { "count"=> public_ip_addresses.count, "publicipaddress"=> public_ip_addresses.values } }
        end
      end

    end
  end
end

