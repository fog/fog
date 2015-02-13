require 'fog/google/core'

module Fog
  module Google
    class SQL < Fog::Service
      requires :google_project
      recognizes :google_client_email, :google_key_location, :google_key_string, :google_client,
                 :app_name, :app_version, :google_json_key_location, :google_json_key_string

      GOOGLE_SQL_API_VERSION    = 'v1beta3'
      GOOGLE_SQL_BASE_URL       = 'https://www.googleapis.com/sql/'
      GOOGLE_SQL_API_SCOPE_URLS = %w(https://www.googleapis.com/auth/sqlservice.admin
                                     https://www.googleapis.com/auth/cloud-platform)

      ##
      # MODELS
      model_path 'fog/google/models/sql'

      # Backup Run
      model :backup_run
      collection :backup_runs

      # Flag
      model :flag
      collection :flags

      # Instance
      model :instance
      collection :instances

      # Operation
      model :operation
      collection :operations

      # SSL Certificate
      model :ssl_cert
      collection :ssl_certs

      # Tier
      model :tier
      collection :tiers

      ##
      # REQUESTS
      request_path 'fog/google/requests/sql'

      # Backup Run
      request :get_backup_run
      request :list_backup_runs

      # Flag
      request :list_flags

      # Instance
      request :clone_instance
      request :delete_instance
      request :export_instance
      request :get_instance
      request :import_instance
      request :insert_instance
      request :list_instances
      request :reset_instance_ssl_config
      request :restart_instance
      request :restore_instance_backup
      request :set_instance_root_password
      request :update_instance

      # Operation
      request :get_operation
      request :list_operations

      # SSL Certificate
      request :delete_ssl_cert
      request :get_ssl_cert
      request :insert_ssl_cert
      request :list_ssl_certs

      # Tier
      request :list_tiers

      class Mock
        include Fog::Google::Shared

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_SQL_API_VERSION, GOOGLE_SQL_BASE_URL)
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :backup_runs => {},
              :instances => {},
              :operations => {},
              :ssl_certs => {},
            }
          end
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data[project]
        end

        def reset_data
          self.class.data.delete(project)
        end

        def random_operation
          "operation-#{Fog::Mock.random_numbers(13)}-#{Fog::Mock.random_hex(13)}-#{Fog::Mock.random_hex(8)}"
        end
      end

      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :sql

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_SQL_API_VERSION, GOOGLE_SQL_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_SQL_API_SCOPE_URLS.join(' '))

          @client = initialize_google_client(options)
          @sql = @client.discovered_api('sqladmin', api_version)
        end
      end
    end
  end
end
