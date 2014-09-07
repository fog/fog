module Fog
  module Google
    class Monitoring
      ##
      # List metric descriptors that match the query. If the query is not set, then all of the metric descriptors
      # will be returned.
      #
      # @see https://developers.google.com/cloud-monitoring/v2beta1/metricDescriptors/list
      class Real
        def list_metric_descriptors(options = {})
          api_method = @monitoring.metric_descriptors.list
          parameters = {
            'project' => @project,
          }

          parameters['count'] = options[:count] if options.key?(:count)
          parameters['pageToken'] = options[:page_token] if options.key?(:page_token)
          parameters['query'] = options[:query] if options.key?(:query)

          request(api_method, parameters)
        end
      end

      class Mock
        def list_metric_descriptors(options = {})
          body = {
            'kind' => 'cloudmonitoring#listMetricDescriptorsResponse',
            'metrics' => [
              { 'name' => 'compute.googleapis.com/instance/cpu/reserved_cores',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'gauge', 'valueType' => 'double' },
                'description' => 'Number of cores reserved on the host of the instance.'
              },
              {
                'name' => 'compute.googleapis.com/instance/cpu/usage_time',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'double' },
                'description' => 'Delta CPU usage time. Units are seconds. You can get the per-core CPU utilization ratio by performing a rate operation on a point: doubleValue/(end-start), then divide by compute.googleapis.com/instance/cpu/reserved_cores at the corresponding end timestamp.'
              },
              {
                'name' => 'compute.googleapis.com/instance/disk/read_bytes_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/device_name' },
                  { 'key' => 'compute.googleapis.com/device_type' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of bytes read from disk.'
              },
              {
                'name' => 'compute.googleapis.com/instance/disk/read_ops_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/device_name' },
                  { 'key' => 'compute.googleapis.com/device_type' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of disk read IO operations.'
              },
              {
                'name' => 'compute.googleapis.com/instance/disk/write_bytes_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/device_name' },
                  { 'key' => 'compute.googleapis.com/device_type' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => '"compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of bytes written to disk.'
              },
              {
                'name' => 'compute.googleapis.com/instance/disk/write_ops_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/device_name' },
                  { 'key' => '"compute.googleapis.com/device_type' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of disk write IO operations.'
              },
              {
                'name' => 'compute.googleapis.com/instance/network/received_bytes_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/loadbalanced' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of bytes received from network.'
              },
              {
                'name' => 'compute.googleapis.com/instance/network/received_packets_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/loadbalanced' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of packets received from network.'
              },
              {
                'name' => 'compute.googleapis.com/instance/network/sent_bytes_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/loadbalanced' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of bytes sent over network.'
              },
              {
                'name' => 'compute.googleapis.com/instance/network/sent_packets_count',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'compute.googleapis.com/loadbalanced' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'int64' },
                'description' => 'Delta count of packets sent over network.'
              },
              {
                'name' => 'compute.googleapis.com/instance/uptime',
                'project' => @project,
                'labels' => [
                  { 'key' => 'compute.googleapis.com/instance_name' },
                  { 'key' => 'cloud.googleapis.com/location' },
                  { 'key' => 'compute.googleapis.com/resource_id' },
                  { 'key' => 'compute.googleapis.com/resource_type' },
                  { 'key' => 'cloud.googleapis.com/service' }
                ],
                'typeDescriptor' => { 'metricType' => 'delta', 'valueType' => 'double' },
                'description' => 'Indicates the VM running time in seconds.'
              },
            ]
          }

          build_excon_response(body)
        end
      end
    end
  end
end
