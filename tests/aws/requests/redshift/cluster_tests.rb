Shindo.tests('Fog::Redshift[:aws] | cluster requests', ['aws']) do

  @describe_clusters_format = {
    "ClusterSet" => [{
      "EndPoint" => {
        "Port"    => Integer,
        "Address" => String,
        "AutomatedSnapshotRetentionPeriod" => Integer,
        "ClusterCreateTime"          => Time
      },
      "ClusterSecurityGroups"      => [{
        "Status"                   => String, 
        "ClusterSecurityGroupName" => String
      }],
      "VpcSecurityGroups"      => Fog::Nullable::Array,
      "ClusterParameterGroups" => [{
        "ParameterApplyStatus" => String,
        "ParameterGroupName"   => String
      }],
      "PendingModifiedValues" => Fog::Nullable::Hash,
      "RestoreStatus"         => Fog::Nullable::Hash,
      "ClusterVersion"        => String,
      "ClusterStatus"         => String,
      "Encrypted"             => Fog::Boolean,
      "NumberOfNodes"         => Integer,
      "PubliclyAccessible"    => Fog::Boolean,
      "DBName"                => String,
      "PreferredMaintenanceWindow" => String,
      "AvailabilityZone"      => String,
      "NodeType"              => String,
      "ClusterIdentifier"     => String,
      "AllowVersionUpgrade"   => Fog::Boolean,
      "MasterUsername"        => String
    }]
  }
  
  tests('success') do
    tests("#describe_clusters").formats(@describe_clusters_format) do
      body = Fog::AWS[:redshift].describe_clusters.body
      body
    end
  end

  # tests('failure') do

  #   tests("#get_console_output('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
  #     Fog::Compute[:aws].get_console_output('i-00000000')
  #   end

  #   tests("#get_password_data('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
  #     Fog::Compute[:aws].get_password_data('i-00000000')
  #   end

  #   tests("#reboot_instances('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
  #     Fog::Compute[:aws].reboot_instances('i-00000000')
  #   end

  #   tests("#terminate_instances('i-00000000')").raises(Fog::Compute::AWS::NotFound) do
  #     Fog::Compute[:aws].terminate_instances('i-00000000')
  #   end

  # end

end
