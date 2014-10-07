module Fog
  module Google
    class SQL
      ##
      # Lists all available service tiers for Google Cloud SQL
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/tiers/list

      class Real
        def list_tiers
          api_method = @sql.tiers.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end

      class Mock
        def list_tiers
          body = {
            'kind' => 'sql#tiersList',
            'items' => [
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D0',
                'RAM'       => '134217728',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D1',
                'RAM'       => '536870912',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D2',
                'RAM'       => '1073741824',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D4',
                'RAM'       => '2147483648',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D8',
                'RAM'       => '4294967296',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D16',
                'RAM'       => '8589934592',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central', 'europe-west1', 'asia-east1'],
              },
              {
                'kind'      => 'sql#tier',
                'tier'      => 'D32',
                'RAM'       => '17179869184',
                'DiskQuota' => '268435456000',
                'region'    => ['us-central'],
              },
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
