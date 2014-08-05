module Fog
  module Google
    class Monitoring
      ##
      # List the descriptors of the time series that match the metric and labels values and that have data points
      # in the interval.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/timeseriesDescriptors/list
      class Real
        def list_timeseries_descriptors(metric, youngest, options = {})
          api_method = @monitoring.timeseries_descriptors.list
          parameters = {
            'project' => @project,
            'metric' => metric,
            'youngest' => youngest,
          }

          parameters['count'] = options[:count] if options.key?(:count)
          parameters['labels'] = options[:labels] if options.key?(:labels)
          parameters['oldest'] = options[:oldest] if options.key?(:oldest)
          parameters['pageToken'] = options[:page_token] if options.key?(:page_token)
          parameters['timespan'] = options[:timespan] if options.key?(:timespan)

          request(api_method, parameters)
        end
      end

      class Mock
        def list_timeseries_descriptors(metric, youngest, options = {})
          body = {
            'kind' => 'cloudmonitoring#listTimeseriesDescriptorsResponse',
            'youngest' => youngest,
            'oldest' => youngest,
            'timeseries' => [
              {
                'project' => @project,
                'metric' => metric,
                'labels' => {
                  'cloud.googleapis.com/service' => 'compute.googleapis.com',
                  'compute.googleapis.com/resource_type' => 'instance',
                  'cloud.googleapis.com/location' => 'us-central1-a',
                  'compute.googleapis.com/resource_id' => Fog::Mock.random_numbers(20).to_s,
                  'compute.googleapis.com/instance_name' => Fog::Mock.random_hex(40),
                },
              },
              {
                'project' => @project,
                'metric' => metric,
                'labels' => {
                  'cloud.googleapis.com/service' => 'compute.googleapis.com',
                  'compute.googleapis.com/resource_type' => 'instance',
                  'cloud.googleapis.com/location' => 'us-central1-a',
                  'compute.googleapis.com/resource_id' => Fog::Mock.random_numbers(20).to_s,
                  'compute.googleapis.com/instance_name' => Fog::Mock.random_hex(40),
                 },
              },
              {
                'project' => @project,
                'metric' => metric,
                'labels' => {
                  'cloud.googleapis.com/service' => 'compute.googleapis.com',
                  'compute.googleapis.com/resource_type' => 'instance',
                  'cloud.googleapis.com/location' => 'us-central1-a',
                  'compute.googleapis.com/resource_id' => Fog::Mock.random_numbers(20).to_s,
                  'compute.googleapis.com/instance_name' => Fog::Mock.random_hex(40),
                 },
              },
              {
                'project' => @project,
                'metric' => metric,
                'labels' => {
                  'cloud.googleapis.com/service' => 'compute.googleapis.com',
                  'compute.googleapis.com/resource_type' => 'instance',
                  'cloud.googleapis.com/location' => 'us-central1-a',
                  'compute.googleapis.com/resource_id' => Fog::Mock.random_numbers(20).to_s,
                  'compute.googleapis.com/instance_name' => Fog::Mock.random_hex(40),
                 },
              },
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
