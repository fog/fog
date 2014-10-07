def test
  connection = Fog::Google::Monitoring.new

  puts 'Listing all MetricDescriptors...'
  puts '--------------------------------'
  connection.metric_descriptors

  puts 'Listing all MetricDescriptors related to Google Compute Engine...'
  puts '-----------------------------------------------------------------'
  connection.metric_descriptors.all(:query => 'compute')
end
