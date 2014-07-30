require 'fog/core/model'

module Fog
  module Google
    class SQL
      class Instance < Fog::Model
        identity :instance

        attribute :current_disk_size, :aliases => 'currentDiskSize'
        attribute :database_version, :aliases => 'databaseVersion'
        attribute :etag
        attribute :ip_addresses, :aliases => 'ipAddresses'
        attribute :kind
        attribute :max_disk_size, :aliases => 'maxDiskSize'
        attribute :project
        attribute :region
        attribute :server_ca_cert, :aliases => 'serverCaCert'
        attribute :settings
        attribute :state

        # These attributes are not available in the representation of an 'Instance' returned by the Google SQL API.
        attribute :activation_policy
        attribute :autorized_gae_applications
        attribute :backup_configuration
        attribute :database_flags
        attribute :ip_configuration_authorized_networks
        attribute :ip_configuration_enabled
        attribute :ip_configuration_require_ssl
        attribute :location_preference_zone_follow_gae_application
        attribute :location_preference_zone
        attribute :pricing_plan
        attribute :replication_type
        attribute :settings_version
        attribute :tier

        MAINTENANCE_STATE    = 'MAINTENANCE'
        PENDING_CREATE_STATE = 'PENDING_CREATE'
        RUNNABLE_STATE       = 'RUNNABLE'
        SUSPENDED_STATE      = 'SUSPENDED'
        UNKNOWN_STATE        = 'UNKNOWN_STATE'

        ##
        # Returns the activation policy for this instance
        #
        # @return [String] The activation policy for this instance
        def activation_policy
          self.settings['activationPolicy']
        end

        ##
        # Returns the AppEngine app ids that can access this instance
        #
        # @return [Array<String>] The AppEngine app ids that can access this instance
        def autorized_gae_applications
          self.settings['authorizedGaeApplications']
        end

        ##
        # Returns the daily backup configuration for the instance
        #
        # @return [Array<Hash>] The daily backup configuration for the instance
        def backup_configuration
          self.settings['backupConfiguration']
        end

        ##
        # Creates a Cloud SQL instance as a clone of the source instance
        #
        # @param [String] destination_name Name of the Cloud SQL instance to be created as a clone
        # @param [Hash] options Method options
        # @option options [String] :log_filename Name of the binary log file for a Cloud SQL instance
        # @option options [Integer] :log_position Position (offset) within the binary log file
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def clone(destination_name, options = {})
          requires :identity

          data = service.clone_instance(self.identity, destination_name, options)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Creates a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def create
          requires :identity

          data = service.insert_instance(self.identity, self.attributes[:tier], self.attributes)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          operation.wait_for { !pending? }
          reload
        end

        ##
        # Returns the database flags passed to the instance at startup
        #
        # @return [Array<Hash>] The database flags passed to the instance at startup
        def database_flags
          self.settings['databaseFlags']
        end

        ##
        # Deletes a Cloud SQL instance
        #
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def destroy(options = {})
          requires :identity

          data = service.delete_instance(self.identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            # DISABLED: A delete instance operation never reachs a 'DONE' state (bug?)
            # operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Exports data from a Cloud SQL instance to a Google Cloud Storage bucket as a MySQL dump file
        #
        # @param [String] uri The path to the file in Google Cloud Storage where the export will be stored,
        #   or where it was already stored
        # @param [Hash] options Method options
        # @option options [Array<String>] :databases Databases (for example, guestbook) from which the export is made.
        #   If unspecified, all databases are exported.
        # @option options [Array<String>] :tables Tables to export, or that were exported, from the specified database.
        #   If you specify tables, specify one and only one database.
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def export(uri, options = {})
          requires :identity

          data = service.export_instance(self.identity, uri, options)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Imports data into a Cloud SQL instance from a MySQL dump file in Google Cloud Storage
        #
        # @param [Array<String>] uri A path to the MySQL dump file in Google Cloud Storage from which the import is
        #   made
        # @param [Hash] options Method options
        # @option options [String] :database The database (for example, guestbook) to which the import is made.
        #   If not set, it is assumed that the database is specified in the file to be imported.
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def import(uri, options = {})
          requires :identity

          data = service.import_instance(self.identity, uri, options)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Returns the list of external networks that are allowed to connect to the instance using the IP
        #
        # @return [Array<String>] The list of external networks that are allowed to connect to the instance using the IP
        def ip_configuration_authorized_networks
          self.settings.fetch('ipConfiguration', {})['authorizedNetworks']
        end

        ##
        # Returns whether the instance should be assigned an IP address or not
        #
        # @return [Boolean] Whether the instance should be assigned an IP address or not
        def ip_configuration_enabled
          self.settings.fetch('ipConfiguration', {})['enabled']
        end

        ##
        # Returns whether the mysqld should default to 'REQUIRE X509' for users connecting over IP
        #
        # @return [Boolean] Whether the mysqld should default to 'REQUIRE X509' for users connecting over IP
        def ip_configuration_require_ssl
          self.settings.fetch('ipConfiguration', {})['requireSsl']
        end

        ##
        # Returns the AppEngine application to follow
        #
        # @return [String] The AppEngine application to follow
        def location_preference_zone_follow_gae_application
          self.settings.fetch('locationPreference', {})['followGaeApplication']
        end

        ##
        # Returns the preferred Compute Engine zone
        #
        # @return [String] The preferred Compute Engine zone
        def location_preference_zone
          self.settings.fetch('locationPreference', {})['zone']
        end

        ##
        # Returns the pricing plan for this instance
        #
        # @return [String] The pricing plan for this instance
        def pricing_plan
          self.settings['pricingPlan']
        end

        ##
        # Checks if the instance is running
        #
        # @return [Boolean] True if the instance is running; False otherwise
        def ready?
          self.state == RUNNABLE_STATE
        end

        ##
        # Returns the type of replication this instance uses
        #
        # @return [String] The type of replication this instance uses
        def replication_type
          self.settings['replicationType']
        end

        ##
        # Deletes all client certificates and generates a new server SSL certificate for the instance
        #
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def reset_ssl_config(options = {})
          requires :identity

          data = service.reset_instance_ssl_config(self.identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Restarts a Cloud SQL instance
        #
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def restart(options = {})
          requires :identity

          data = service.restart_instance(self.identity)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Restores a backup of a Cloud SQL instance
        #
        # @param [String] backup_configuration The identifier of the backup configuration
        # @param [String] due_time The time when this run is due to start in RFC 3339 format
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def restore_backup(backup_configuration, due_time, options = {})
          requires :identity

          data = service.restore_instance_backup(self.identity, backup_configuration, due_time)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Saves a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def save
          self.etag ? update : create
        end

        ##
        # Sets the password for the root user
        #
        # @param [String] password The password for the root user
        # @param [Hash] options Method options
        # @option options [Boolean] :async If the operation must be performed asynchronously (true by default)
        # @return [Fog::Google::SQL::Operation] A Operation resource
        def set_root_password(password, options = {})
          requires :identity

          data = service.set_instance_root_password(self.identity, password)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          unless options.fetch(:async, true)
            operation.wait_for { ready? }
          end
          operation
        end

        ##
        # Returns the version of instance settings
        #
        # @return [String] The version of instance settings
        def settings_version
          self.settings['settingsVersion']
        end

        ##
        # Lists all of the current SSL certificates for the instance
        #
        # @return [Array<Fog::Google::SQL::SslCert>] List of SSL certificate resources
        def ssl_certs
          requires :identity

          service.ssl_certs.all(self.identity)
        end

        ##
        # Returns the tier of service for this instance
        #
        # @return [String] The tier of service for this instance
        def tier
          self.settings['tier']
        end

        ##
        # Updates settings of a Cloud SQL instance
        #
        # @return [Fog::Google::SQL::Instance] Instance resource
        def update
          requires :identity

          data = service.update_instance(self.identity, self.settings_version, self.tier, self.attributes)
          operation = Fog::Google::SQL::Operations.new(:service => service).get(self.instance, data.body['operation'])
          operation.wait_for { !pending? }
          reload
        end
      end
    end
  end
end
