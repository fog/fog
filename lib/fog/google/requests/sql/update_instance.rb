module Fog
  module Google
    class SQL
      ##
      # Updates settings of a Cloud SQL instance
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/instances/update

      class Real
        def update_instance(instance_id, settings_version, tier, options = {})
          api_method = @sql.instances.update
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          body = {
            'project' => @project,
            'instance' => instance_id,
            'settings' => {
              'settingsVersion' => settings_version,
              'tier' => tier,
            }
          }

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
        def update_instance(instance_id, settings_version, tier, options = {})
          data = self.data[:instances][instance_id]
          data['tier'] = tier
          if options[:activation_policy]
            data['settings']['activationPolicy'] = options[:activation_policy]
          end
          if options[:autorized_gae_applications]
            data['settings']['authorizedGaeApplications'] = Array(options[:autorized_gae_applications])
          end
          if options[:backup_configuration]
            data['settings']['backupConfiguration'] = options[:backup_configuration]
          end
          if options[:ip_configuration_authorized_networks]
            data['settings']['ipConfiguration'] ||= {}
            data['settings']['ipConfiguration']['authorizedNetworks'] = Array(options[:ip_configuration_authorized_networks])
          end
          if options[:ip_configuration_enabled]
            data['settings']['ipConfiguration'] ||= {}
            data['settings']['ipConfiguration']['enabled'] = options[:ip_configuration_enabled]
          end
          if options[:ip_configuration_require_ssl]
            data['settings']['ipConfiguration'] ||= {}
            data['settings']['ipConfiguration']['requireSsl'] = options[:ip_configuration_require_ssl]
          end
          if options[:location_preference_zone_follow_gae_application]
            data['settings']['locationPreference'] ||= {}
            data['settings']['locationPreference']['followGaeApplication'] = options[:location_preference_zone_follow_gae_application]
          end
          if options[:location_preference_zone]
            data['settings']['locationPreference'] ||= {}
            data['settings']['locationPreference']['zone'] = options[:location_preference_zone]
          end
          if options[:pricing_plan]
            data['settings']['pricingPlan'] = options[:pricing_plan]
          end
          if options[:replication_type]
            data['settings']['replicationType'] = options[:replication_type]
          end
          self.data[:instances][instance_id] = data

          operation = self.random_operation
          self.data[:operations][instance_id] ||= {}
          self.data[:operations][instance_id][operation] = {
            'kind' => 'sql#instanceOperation',
            'instance' => instance_id,
            'operation' => operation,
            'operationType' => 'UPDATE',
            'state' => Fog::Google::SQL::Operation::DONE_STATE,
            'userEmailAddress' => 'google_client_email@developer.gserviceaccount.com',
            'enqueuedTime' => Time.now.iso8601,
            'startTime' => Time.now.iso8601,
            'endTime' => Time.now.iso8601,
          }

          body = {
            'kind' => 'sql#instancesUpdate',
            'operation' => operation,
          }
          status = 200

          build_excon_response(body, status)
        end
      end
    end
  end
end