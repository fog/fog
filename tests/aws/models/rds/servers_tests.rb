Shindo.tests("AWS::RDS | servers", ['aws', 'rds']) do

  params = {:id => uniq_id, :allocated_storage => 5, :engine => 'mysql',
    :master_username => 'foguser', :password => 'fogpassword',
    :backup_retention_period => 0
  }

  collection_tests(AWS[:rds].servers, params, false)
end
