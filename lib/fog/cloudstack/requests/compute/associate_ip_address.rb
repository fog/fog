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

    end
  end
end

