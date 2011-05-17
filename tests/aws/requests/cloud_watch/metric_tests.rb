Shindo.tests('AWS::CloudWatch | metric requests', ['aws', 'cloudwatch']) do
  
  tests('success') do
    @metrics_list_format = {
      'ListMetricsResult' => {
        'Metrics' => 
          [{
            'Dimensions' => 
            [{
              'Name' => String,
              'Value' => String
            }],
            "MetricName" => String,
            "Namespace" => String
          }],
      }, 
      'ResponseMetadata' => {"RequestId"=> String}
    }
    
    tests("#list_metrics").formats(@metrics_list_format) do
      AWS[:cloud_watch].list_metrics.body
    end
  end
end