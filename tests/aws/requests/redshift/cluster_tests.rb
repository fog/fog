Shindo.tests('Fog::Redshift[:aws] | cluster requests', ['aws']) do

  identifier = "test-cluster-#{rand(65536).to_s(16)}"

  @cluster_format = { 
    "ClusterParameterGroups" => [{
      "ParameterApplyStatus" => String,
      "ParameterGroupName"   => String
    }],
    "ClusterSecurityGroups"      => [{
      "Status"                   => String,
      "ClusterSecurityGroupName" => String
    }],
    "VpcSecurityGroups"     => Fog::Nullable::Array,
    "EndPoint"              => Fog::Nullable::Hash, 
    "PendingModifiedValues" => Fog::Nullable::Hash, #{"MasterUserPassword"  => String}, 
    "RestoreStatus"         => Fog::Nullable::Hash,
    "ClusterVersion"        => String,
    "ClusterStatus"         => String,
    "Encrypted"             => Fog::Boolean,
    "NumberOfNodes"         => Integer,
    "PubliclyAccessible"    => Fog::Boolean,
    "AutomatedSnapshotRetentionPeriod" => Integer,
    "DBName"                => String,
    "PreferredMaintenanceWindow" => String,
    "NodeType"              => String,
    "ClusterIdentifier"     => String,
    "AllowVersionUpgrade"   => Fog::Boolean,
    "MasterUsername"        => String
  }

  @describe_clusters_format = {
    "ClusterSet" => [
      @cluster_format.merge({"ClusterCreateTime"=>Time, "AvailabilityZone"=>String, "EndPoint"=>{"Port"=>Integer, "Address"=>String}})
    ]      
  }

  tests('success') do
    tests("create_cluster").formats(@cluster_format) do
      body = Fog::AWS[:redshift].create_cluster(:cluster_identifier   => identifier, 
                                                :master_user_password => 'Password1234', 
                                                :master_username      => 'testuser',
                                                :node_type            => 'dw.hs1.xlarge', 
                                                :cluster_type         => 'single-node').body
      Fog.wait_for do
        "available" == Fog::AWS[:redshift].describe_clusters(:cluster_identifier=>identifier).body['ClusterSet'].first['ClusterStatus']
      end
      body
    end


    tests("#describe_clusters").formats(@describe_clusters_format["ClusterSet"]) do
      body = Fog::AWS[:redshift].describe_clusters(:cluster_identifier=>identifier).body["ClusterSet"]
      body
    end


    tests("#reboot_cluster") do
      sleep 30
      body = Fog::AWS[:redshift].reboot_cluster(:cluster_identifier=>identifier).body
      tests("verify reboot").returns("rebooting") { body['ClusterStatus']}
      Fog.wait_for do
        "available" == Fog::AWS[:redshift].describe_clusters(:cluster_identifier=>identifier).body['ClusterSet'].first['ClusterStatus']
      end
      body
    end


    tests("#delete_cluster") do
      sleep 30
      body = Fog::AWS[:redshift].delete_cluster(:cluster_identifier=>identifier, :skip_final_cluster_snapshot=>true).body
      tests("verify delete").returns("deleting") { body['ClusterStatus']}
      body
    end


  end

  # tests('failure') do
  # end

end
