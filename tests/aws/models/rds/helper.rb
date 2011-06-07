def rds_default_server_params
  { :id => uniq_id, :allocated_storage => 5, :engine => 'mysql',
    :master_username => 'foguser', :password => 'fogpassword',
    :backup_retention_period => 0 }
end
