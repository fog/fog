require 'date'
module Fog
  module DNS
    class Google
      ##
      # Creates a new Managed Zone.
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/managedZones/create
      class Real
        def create_managed_zone(name, dns_name, description)
          api_method = @dns.managed_zones.create
          parameters = {
            'project' => @project,
          }

          body_object = {
            'name' => name,
            'dnsName' => dns_name,
            'description' => description,
          }

          request(api_method, parameters, body_object)
        end
      end

      class Mock
        def create_managed_zone(name, dns_name, description)
          id = Fog::Mock.random_numbers(19).to_s
          data = {
            'kind' => 'dns#managedZone',
            'id' => id,
            'creationTime' => DateTime.now.strftime('%FT%T.%LZ'),
            'name' => name,
            'dnsName' => dns_name,
            'description' => description,
            'nameServers' => [
              'ns-cloud-e1.googledomains.com.',
              'ns-cloud-e2.googledomains.com.',
              'ns-cloud-e3.googledomains.com.',
              'ns-cloud-e4.googledomains.com.',
            ],
          }
          self.data[:managed_zones][id] = data
          self.data[:resource_record_sets][id] = [
            {
              'kind' => 'dns#resourceRecordSet',
              'name' => dns_name,
              'type' => 'NS',
              'ttl' => 21600,
              'rrdatas' => [
                'ns-cloud-c1.googledomains.com.',
                'ns-cloud-c2.googledomains.com.',
                'ns-cloud-c3.googledomains.com.',
                'ns-cloud-c4.googledomains.com.',
              ]
            },
            {
              'kind' => 'dns#resourceRecordSet',
              'name' => dns_name,
              'type' => 'SOA',
              'ttl' => 21600,
              'rrdatas' => [
                'ns-cloud-c1.googledomains.com. dns-admin.google.com. 0 21600 3600 1209600 300',
              ]
            },
          ]
          self.data[:changes][id] = [
            {
              'kind' => 'dns#change',
              'id' => '0',
              'startTime' => DateTime.now.strftime('%FT%T.%LZ'),
              'status' => 'done',
              'additions' => self.data[:resource_record_sets][id],
            },
          ]

          build_excon_response(data)
        end
      end
    end
  end
end
