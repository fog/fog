Shindo.tests('AWS::IAM | user requests', ['aws']) do

  Fog::AWS[:iam].create_group('fog_user_tests')

  tests('success') do

    @user_format = {
      'User' => {
        'Arn'       => String,
        'Path'      => String,
        'UserId'    => String,
        'UserName'  => String
      },
      'RequestId' => String
    }

    tests("#create_user('fog_user')").formats(@user_format) do
      Fog::AWS[:iam].create_user('fog_user').body
    end

    @users_format = {
      'Users' => [{
        'Arn'       => String,
        'Path'      => String,
        'UserId'    => String,
        'UserName'  => String
      }],
      'IsTruncated' => Fog::Boolean,
      'RequestId'   => String
    }

    tests("#list_users").formats(@users_format) do
      Fog::AWS[:iam].list_users.body
    end

    tests("#add_user_to_group('fog_user_tests', 'fog_user')").formats(AWS::IAM::Formats::BASIC) do
      Fog::AWS[:iam].add_user_to_group('fog_user_tests', 'fog_user').body
    end

    @groups_format = {
      'GroupsForUser' => [{
        'Arn'       => String,
        'GroupId'   => String,
        'GroupName' => String,
        'Path'      => String
      }],
      'IsTruncated' => Fog::Boolean,
      'RequestId'   => String
    }

    tests("#list_groups_for_user('fog_user')").formats(@groups_format) do
      Fog::AWS[:iam].list_groups_for_user('fog_user').body
    end

    tests("#remove_user_from_group('fog_user_tests', 'fog_user')").formats(AWS::IAM::Formats::BASIC) do
      Fog::AWS[:iam].remove_user_from_group('fog_user_tests', 'fog_user').body
    end

    tests("#delete_user('fog_user')").formats(AWS::IAM::Formats::BASIC) do
      Fog::AWS[:iam].delete_user('fog_user').body
    end


  end

  tests('failure') do
    test('failing conditions')
  end

  Fog::AWS[:iam].delete_group('fog_user_tests')

end
