Shindo.tests('AWS::SES | topic lifecycle tests', ['aws', 'sns']) do

  tests('success') do

    tests("#create_topic('TopicArn' => 'example-topic')").formats(AWS::SNS::Formats::BASIC.merge('TopicArn' => String)) do
      pending if Fog.mocking?
      body = AWS[:sns].create_topic('Name' => 'example-topic').body
      @topic_arn = body["TopicArn"]
      body
    end

    tests("#list_topics").formats(AWS::SNS::Formats::BASIC.merge('Topics' => [String])) do
      pending if Fog.mocking?
      AWS[:sns].list_topics.body
    end

    tests("#delete_topic('TopicArn' => 'example-topic')").formats(AWS::SNS::Formats::BASIC) do
      pending if Fog.mocking?
      AWS[:sns].delete_topic('TopicArn' => @topic_arn).body
    end

  end

  tests('failure') do

  end

end
