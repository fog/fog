Shindo.tests('AWS::IAM | group policy requests', ['aws']) do

  AWS[:iam].create_group('fog_group_policy_tests')

  tests('success') do

    @policy = {"Statement" => [{"Effect" => "Allow", "Action" => "*", "Resource" => "*"}]}

    tests("#put_group_policy('fog_group_policy_tests', 'fog_policy', #{@policy.inspect})").formats(AWS::IAM::Formats::BASIC) do
      AWS[:iam].put_group_policy('fog_group_policy_tests', 'fog_policy', @policy).body
    end

    @group_policies_format = {
      'IsTruncated' => Fog::Boolean,
      'PolicyNames' => [String],
      'RequestId'   => String
    }

    tests("list_group_policies('fog_group_policy_tests')").formats(@group_policies_format) do
      AWS[:iam].list_group_policies('fog_group_policy_tests').body
    end

    tests("#delete_group_policy('fog_group_policy_tests', 'fog_policy')").formats(AWS::IAM::Formats::BASIC) do
      AWS[:iam].delete_group_policy('fog_group_policy_tests', 'fog_policy').body
    end

  end

  tests('failure') do
    test('failing conditions')
  end

  AWS[:iam].delete_group('fog_group_policy_tests')

end