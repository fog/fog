Shindo.tests('AWS::AutoScaling | describe types requests', ['aws', 'auto_scaling']) do

  tests('success') do

    tests("#describe_adjustment_types").formats(AWS::AutoScaling::Formats::DESCRIBE_ADJUSTMENT_TYPES) do
      Fog::AWS[:auto_scaling].describe_adjustment_types.body
    end

    tests("#describe_auto_scaling_notification_types").formats(AWS::AutoScaling::Formats::DESCRIBE_AUTO_SCALING_NOTIFICATION_TYPES) do
      Fog::AWS[:auto_scaling].describe_auto_scaling_notification_types.body
    end

    tests("#describe_metric_collection_types").formats(AWS::AutoScaling::Formats::DESCRIBE_METRIC_COLLECTION_TYPES) do
      Fog::AWS[:auto_scaling].describe_metric_collection_types.body
    end

    tests("#describe_scaling_process_types").formats(AWS::AutoScaling::Formats::DESCRIBE_SCALING_PROCESS_TYPES) do
      Fog::AWS[:auto_scaling].describe_scaling_process_types.body
    end

    tests("#describe_termination_policy_types").formats(AWS::AutoScaling::Formats::DESCRIBE_TERMINATION_POLICY_TYPES) do
      Fog::AWS[:auto_scaling].describe_termination_policy_types.body
    end

  end

end
