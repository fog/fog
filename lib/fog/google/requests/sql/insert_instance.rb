module Fog
  module Google
    class SQL
      ##
      # Creates a new Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/insert

      class Real
        def insert_instance(name, tier, options = {})
          api_method = @sql.instances.insert
          parameters = {
            'project' => @project,
          }

          body = {
            'project' => @project,
            'instance' => name,
            'settings' => {
              'tier' => tier,
            }
          }

          if options[:region]
            body['region'] = options[:region]
          end
          if options[:activation_policy]
            body['settings']['activationPolicy'] = options[:activation_policy]
          end
          if options[:autorized_gae_applications]
            body['settings']['authorizedGaeApplications'] = Array(options[:autorized_gae_applications])
          end
          if options[:backup_configuration]
            body['settings']['backupConfiguration'] = options[:backup_configuration]
          end
          if options[:ip_configuration_authorized_networks]
            body['settings']['ipConfiguration'] ||= {}
            body['settings']['ipConfiguration']['authorizedNetworks'] = Array(options[:ip_configuration_authorized_networks])
          end
          if options[:ip_configuration_enabled]
            body['settings']['ipConfiguration'] ||= {}
            body['settings']['ipConfiguration']['enabled'] = options[:ip_configuration_enabled]
          end
          if options[:ip_configuration_require_ssl]
            body['settings']['ipConfiguration'] ||= {}
            body['settings']['ipConfiguration']['requireSsl'] = options[:ip_configuration_require_ssl]
          end
          if options[:location_preference_zone_follow_gae_application]
            body['settings']['locationPreference'] ||= {}
            body['settings']['locationPreference']['followGaeApplication'] = options[:location_preference_zone_follow_gae_application]
          end
          if options[:location_preference_zone]
            body['settings']['locationPreference'] ||= {}
            body['settings']['locationPreference']['zone'] = options[:location_preference_zone]
          end
          if options[:pricing_plan]
            body['settings']['pricingPlan'] = options[:pricing_plan]
          end
          if options[:replication_type]
            body['settings']['replicationType'] = options[:replication_type]
          end

          request(api_method, parameters, body)
        end
      end

      class Mock
        def insert_instance(name, tier, options = {})
          data = {
            'kind' => 'sql#instance',
            'instance' => name,
            'etag' => Fog::Mock.random_base64(32),
            'project' => @project,
            'state' => Fog::Google::SQL::Instance::RUNNABLE_STATE ,
            'databaseVersion' => 'MYSQL_5_5',
            'region' => options[:region] || 'us-central',
            'currentDiskSize' => '86245269',
            'maxDiskSize' => '268435456000',
            'settings' => {
              'kind' => 'sql#settings',
              'settingsVersion' => '1',
              'tier' => tier,
              'backupConfiguration' => [
                {
                  'kind' => 'sql#backupConfiguration',
                  'startTime' => '04:00',
                  'enabled' => false,
                  'id' => Fog::Mock.random_hex(32),
                  'binaryLogEnabled' => false
                }
              ],
              'pricingPlan' => options[:pricing_plan] || 'PER_USE',
              'replicationType' => options[:replication_type] || 'SYNCHRONOUS',
              'activationPolicy' => options[:activation_policy] || 'ON_DEMAND',
              'ipConfiguration' => {
                'enabled' => false,
              },
              'locationPreference' => {
                'kind' => 'sql#locationPreference',
              }
             },
            'serverCaCert' => {
              'kind' => 'sql#sslCert',
              'instance' => name,
              'sha1Fingerprint' => Fog::Mock.random_hex(40),
              'commonName' => 'C=US,O=Google\\, Inc,CN=Google Cloud SQL Server CA',
              'certSerialNumber' => '0',
              'cert' => "-----BEGIN CERTIFICATE-----\nMIIDITCCAgmgAwIBAgIBADANBgkqhkiG9w0BAQUFADBIMSMwIQYDVQQDExpHb29n\nbGUgQ2xvdWQgU1FMIFNlcnZlciBDQTEUMBIGA1UEChMLR29vZ2xlLCBJbmMxCzAJ\nBgNVBAYTAlVTMB4XDTE0MDYwNDA1MjkxMVoXDTI0MDYwMTA1MjkxMVowSDEjMCEG\nA1UEAxMaR29vZ2xlIENsb3VkIFNRTCBTZXJ2ZXIgQ0ExFDASBgNVBAoTC0dvb2ds\nZSwgSW5jMQswCQYDVQQGEwJVUzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC\nggEBALlRjq3zccH5ed6NMfCFcTYd9XxYXyvLurxxjDIA6A7/ymVM9qdQC0uckf7C\nsi4uMi2yfK+PHZ0jXC+g0uPx5RTm+nbKl4I++VOh2g6oZHeNdFt4rVJpr+jzGUMf\nr67SymUr70TQOTEVpx2Ud3rBB2szulxWUSXEy2AGA3uNUGe/IgENh7p56s00Sr97\nTRP1S5/JVMalncgNVLH2nNqBQJZTx9t9qvGatoUfmHUU0+M//J5sXLbgdzeEeeot\nHJUyoXjA2sRkH1+F/d6PpFrcr1I8dVmCBEbTAnm7HpKh5Mx2nRYi+t/y9D2Mblwx\n9dBRfr3WIJ1JDxzt3L8CtBGZbvUCAwEAAaMWMBQwEgYDVR0TAQH/BAgwBgEB/wIB\nADANBgkqhkiG9w0BAQUFAAOCAQEAmHuBecPc265sbd26B1HXUAD6FHdzoZLrAZVW\n+1eIK4E669P4y6LkLuoCkLd64/YwA4K2FioksqgHOahbYWJJYPymy4ae+IPXzXcY\nPv3gmBsKk++sHb64D9Cj/k5n8BEiVmmrsUCUiL75nJAzK+El3hvKKWWl76XX/qHP\nk8ZAxIrn8bCiVOaj6NR4+p1OmcZSPNWxz7j/EwQxoABRxgPgt+B/YRseevww7an2\n/rGs0sk7RE0QDjLfZblYGh+xVPBBLuLmf4L5JNJkFEoeGSWrxTzvXnS+2LZeHdM/\nJ9nsiKu5JKPhMUS0vOcTymOkh8tJ6Np8gwg6ca4g6dT3llE6uQ==\n-----END CERTIFICATE-----",
              'createTime' => Time.now.iso8601,
              'expirationTime' => Time.now.iso8601,
            }
          }

          if options[:autorized_gae_applications]
            data['settings']['authorizedGaeApplications'] = Array(options[:autorized_gae_applications])
          end
          if options[:backup_configuration]
            data['settings']['backupConfiguration'] = options[:backup_configuration]
          end
          if options[:ip_configuration_authorized_networks]
            data['settings']['ipConfiguration']['authorizedNetworks'] = Array(options[:ip_configuration_authorized_networks])
          end
          if options[:ip_configuration_enabled]
            data['settings']['ipConfiguration']['enabled'] = options[:ip_configuration_enabled]
          end
          if options[:ip_configuration_require_ssl]
            data['settings']['ipConfiguration']['requireSsl'] = options[:ip_configuration_require_ssl]
          end
          if options[:location_preference_zone_follow_gae_application]
            data['settings']['locationPreference']['followGaeApplication'] = options[:location_preference_zone_follow_gae_application]
          end
          if options[:location_preference_zone]
            data['settings']['locationPreference']['zone'] = options[:location_preference_zone]
          end

          self.data[:instances][name] = data
          self.data[:ssl_certs][name] = {}
          self.data[:backup_runs][name] = {}

          operation = self.random_operation
          self.data[:operations][name] ||= {}
          self.data[:operations][name][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => name,
            'operation' => operation,
            'operationType' => 'CREATE',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesInsert',
            'operation' => operation,
          }
          status = 200

          build_excon_response(body, status)
        end
      end
    end
  end
end
