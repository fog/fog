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
          id = options['id']
          if id && self.data[:flavors][id].nil?
            # received 'id' filter for element that does not exist
            response = { "listserviceofferingsresponse" => { "count" => 0, "serviceoffering" => []}}
          elsif self.data[:flavors][id]
            # received 'id' filter for a specific element
            flavors =  { id => self.data[:flavors][id] }
            response = { "listserviceofferingsresponse" => { "count" => flavors.size, "serviceoffering"=> flavors.values}}
          else
            # no filter specified
            flavors = self.data[:flavors]
            response = { "listserviceofferingsresponse" => { "count" => flavors.size, "serviceoffering"=> flavors.values}}
          end

          return response
        end
      end
    end
  end
end

