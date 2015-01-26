module Fog
  module DNS
    class Google
      ##
      # Fetches the representation of an existing Project. Use this method to look up the limits on the number of
      # resources that are associated with your project.
      #
      # @see https://developers.google.com/cloud-dns/api/v1beta1/projects/get
      class Real
        def get_project(identity)
          api_method = @dns.projects.get
          parameters = {
            :project => identity,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def get_project(identity)
          body = {
            'kind' => 'dns#project',
            'number' => Fog::Mock.random_numbers(12).to_s,
            'id' => identity,
            'quota' => {
              'kind' => 'dns#quota',
              'managedZones' => 100,
              'rrsetsPerManagedZone' => 10000,
              'rrsetAdditionsPerChange' => 100,
              'rrsetDeletionsPerChange'=>100,
              'totalRrdataSizePerChange' => 10000,
              'resourceRecordsPerRrset' => 20,
            }
          }

          build_excon_response(body)
        end
      end
    end
  end
end
