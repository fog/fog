module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available service offerings.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listServiceOfferings.html]
        def list_service_offerings(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listServiceOfferings')
          else
            options.merge!('command' => 'listServiceOfferings')
          end
          request(options)
        end
      end

      class Mock

        def list_service_offerings(options={})
          flavors = self.data[:flavors]

          { "listserviceofferingsresponse" => { "count" => flavors.size, "serviceoffering"=> flavors.values}}
        end
      end
    end
  end
end

