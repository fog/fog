Shindo.tests('AWS::RDS | db instance option requests', ['aws', 'rds']) do
  tests('success') do

    tests("#describe_orderable_db_instance_options('mysql)").formats(AWS::RDS::Formats::DESCRIBE_ORDERABLE_DB_INSTANCE_OPTION) do

      body = Fog::AWS[:rds].describe_orderable_db_instance_options('mysql').body

      returns(2) {body['DescribeOrderableDBInstanceOptionsResult']['OrderableDBInstanceOptions'].length}

      group = body['DescribeOrderableDBInstanceOptionsResult']['OrderableDBInstanceOptions'].first
      returns( true ) { group['MultiAZCapable'] }
      returns( 'mysql' ) { group['Engine'] }
      returns( true ) { group['ReadReplicaCapable'] }
      returns( true ) { group['AvailabilityZones'].length >= 1 }

      body
    end

  end

end
