Shindo.tests('Fog::AWS[:dynamodb] | table requests', ['aws']) do

  @table_format = {
    'KeySchema'             => {
      'HashKeyElement' => {
        'AttributeName' => String,
        'AttributeType' => String
      }
    },
    'ProvisionedThroughput' => {
      'ReadCapacityUnits'   => Integer,
      'WriteCapacityUnits'  => Integer
    },
    'TableName'             => String,
    'TableStatus'           => String
  }

  @table_name = "fog_table_#{Time.now.to_f.to_s.gsub('.','')}"

  tests('success') do

    tests("#create_table(#{@table_name}, {'HashKeyElement' => {'AttributeName' => 'id', 'AttributeType' => 'S'}, {'ReadCapacityUnits' => 5, 'WriteCapacityUnits' => 5})").formats('TableDescription' => @table_format.merge('CreationDateTime' => Float)) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].create_table(@table_name, {'HashKeyElement' => {'AttributeName' => 'id', 'AttributeType' => 'S'}}, {'ReadCapacityUnits' => 5, 'WriteCapacityUnits' => 5}).body
    end

    tests("#describe_table(#{@table_name})").formats('Table' => @table_format.merge('CreationDateTime' => Float)) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].describe_table(@table_name).body
    end

    tests("#list_tables").formats({'LastEvaluatedTableName' => Fog::Nullable::String, 'TableNames' => [String]}) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].list_tables.body
    end

    unless Fog.mocking?
      Fog.wait_for { Fog::AWS[:dynamodb].describe_table(@table_name).body['Table']['TableStatus'] == 'ACTIVE' }
    end

    tests("#update_table(#{@table_name}, {'ReadCapacityUnits' => 10, 'WriteCapacityUnits' => 10})").formats('Table' => @table_format) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].update_table(@table_name, {'ReadCapacityUnits' => 10, 'WriteCapacityUnits' => 10}).body
    end

    unless Fog.mocking?
      Fog.wait_for { Fog::AWS[:dynamodb].describe_table(@table_name).body['Table']['TableStatus'] == 'ACTIVE' }
    end

    tests("#delete_table(#{@table_name}").formats('TableDescription' => @table_format) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].delete_table(@table_name).body
    end

  end

  tests('failure') do

    tests("#delete_table('notatable')").raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].delete_table('notatable')
    end

    tests("#describe_table('notatable')").raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].describe_table('notatable')
    end

    tests("#update_table('notatable', {'ReadCapacityUnits' => 10, 'WriteCapacityUnits' => 10})").raises(Excon::Errors::BadRequest) do
      pending if Fog.mocking?
      Fog::AWS[:dynamodb].update_table('notatable', {'ReadCapacityUnits' => 10, 'WriteCapacityUnits' => 10}).body
    end

  end
end
