require 'date'
module Fog
  module DNS
    class Google

      class Mock
        def create_managed_zone(zone_name, dns_name, descr='')
          id = Fog::Mock.random_numbers(19).to_s
          object = {
            "kind" => "dns#managedZone",
            "id" => id,
            "creationTime" => DateTime.now.strftime('%FT%T.%LZ'),
            "name" => zone_name,
            "dnsName" => dns_name,
            "description" => descr,
	    "nameServers" => [
	      "ns-cloud-e1.googledomains.com.",
	      "ns-cloud-e2.googledomains.com.",
	      "ns-cloud-e3.googledomains.com.",
	      "ns-cloud-e4.googledomains.com.",
	    ],
	  }
          self.data[:managed_zones][:by_name][zone_name] = object
          self.data[:managed_zones][:by_id][id] = object

          build_excon_response(object)
        end

      end

      class Real
        def create_managed_zone(zone_name, dns_name, descr='')
          api_method = @dns.managed_zones.create
          parameters = {
            'project' => @project,
          }

          body_object = {
	    'name' => zone_name,
	    'dnsName' => dns_name,
	  }
	  body_object['description'] = descr unless descr.nil?

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
