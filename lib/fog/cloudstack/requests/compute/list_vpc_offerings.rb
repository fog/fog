module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists VPC offerings
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listVPCOfferings.html]
        def list_vpc_offerings(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listVPCOfferings') 
          else
            options.merge!('command' => 'listVPCOfferings')
          end
          request(options)
        end
      end

    end
  end
end

