require 'fog/google/core'

module Fog
  module Google
    class Monitoring < Fog::Service
      requires :google_project
      recognizes :google_client_email, :google_key_location, :google_key_string, :google_client,
                 :app_name, :app_version

      GOOGLE_MONITORING_API_VERSION    = 'v2beta1'
      GOOGLE_MONITORING_BASE_URL       = 'https://www.googleapis.com/cloudmonitoring/'
      GOOGLE_MONITORING_API_SCOPE_URLS = %w(https://www.googleapis.com/auth/monitoring.readonly)

      ##
      # MODELS
      model_path 'fog/google/models/monitoring'

      # Timeseries
      model :timeseries
      collection :timeseries_collection

      # TimeseriesDescriptors
      model :timeseries_descriptor
      collection :timeseries_descriptors

      # MetricDescriptors
      model :metric_descriptor
      collection :metric_descriptors

      ##
      # REQUESTS
      request_path 'fog/google/requests/monitoring'

      # Timeseries
      request :list_timeseries

      # TimeseriesDescriptors
      request :list_timeseries_descriptors

      # MetricDescriptors
      request :list_metric_descriptors

      class Mock
        include Fog::Google::Shared

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_MONITORING_API_VERSION, GOOGLE_MONITORING_BASE_URL)
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :timeseries => {},
              :timeseries_descriptors => {},
              :metric_descriptors => {},
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
      end

      class Real
        include Fog::Google::Shared

        attr_accessor :client
        attr_reader :monitoring

        def initialize(options)
          shared_initialize(options[:google_project], GOOGLE_MONITORING_API_VERSION, GOOGLE_MONITORING_BASE_URL)
          options.merge!(:google_api_scope_url => GOOGLE_MONITORING_API_SCOPE_URLS.join(' '))

          @client = initialize_google_client(options)
          @monitoring = @client.discovered_api('cloudmonitoring', api_version)
        end
      end
    end
  end
end
