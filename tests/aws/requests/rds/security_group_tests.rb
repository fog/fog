Shindo.tests('AWS::RDS | security group requests', ['aws', 'rds']) do
  suffix = rand(65536).to_s(16)

  @sec_group_name  = "fog-sec-group-#{suffix}"
  @owner_id = Fog::AWS[:rds].security_groups.get('default').owner_id
  
  tests('success') do
    pending if Fog.mocking?

    tests("#create_db_security_group").formats(AWS::RDS::Formats::CREATE_DB_SECURITY_GROUP) do
      pending if Fog.mocking?
      body = Fog::AWS[:rds].create_db_security_group(@sec_group_name, 'Some description').body

      returns( @sec_group_name) { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['DBSecurityGroupName']}
      returns( 'Some description') { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['DBSecurityGroupDescription']}
      returns( []) { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['EC2SecurityGroups']}
      returns( []) { body['CreateDBSecurityGroupResult']['DBSecurityGroup']['IPRanges']}
      
      body
    end
    
    tests("#describe_db_security_groups").formats(AWS::RDS::Formats::DESCRIBE_DB_SECURITY_GROUP) do
      Fog::AWS[:rds].describe_db_security_groups.body
    end
    
    tests("#authorize_db_security_group_ingress CIDR").formats(AWS::RDS::Formats::AUTHORIZE_DB_SECURITY_GROUP) do
      body = Fog::AWS[:rds].authorize_db_security_group_ingress(@sec_group_name,{'CIDRIP'=>'0.0.0.0/0'}).body
      
      returns("0.0.0.0/0") { body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['IPRanges'][0]["CIDRIP"]}
      returns("authorizing") { body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['IPRanges'][0]["Status"]}
      body
    end
    
    sec_group = Fog::AWS[:rds].security_groups.get(@sec_group_name)
    sec_group.wait_for {ready?}
    
    tests("#revoke_db_security_group_ingress CIDR").formats(AWS::RDS::Formats::REVOKE_DB_SECURITY_GROUP) do
      body = Fog::AWS[:rds].revoke_db_security_group_ingress(@sec_group_name,{'CIDRIP'=>'0.0.0.0/0'}).body
      returns("revoking") { body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['IPRanges'][0]["Status"]}
      body
    end
    
    tests("#authorize_db_security_group_ingress EC2").formats(AWS::RDS::Formats::AUTHORIZE_DB_SECURITY_GROUP) do
      body = Fog::AWS[:rds].authorize_db_security_group_ingress(@sec_group_name,{'EC2SecurityGroupName' => 'default', 'EC2SecurityGroupOwnerId' => @owner_id}).body
      
      returns("default") { body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["EC2SecurityGroupName"]}
      returns(@owner_id) { body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["EC2SecurityGroupOwnerId"]}
      returns("authorizing") { body['AuthorizeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["Status"]}
      body
    end
    
    sec_group = Fog::AWS[:rds].security_groups.get(@sec_group_name)
    sec_group.wait_for {ready?}
    
    tests("#revoke_db_security_group_ingress EC2").formats(AWS::RDS::Formats::REVOKE_DB_SECURITY_GROUP) do
      body = Fog::AWS[:rds].revoke_db_security_group_ingress(@sec_group_name,{'EC2SecurityGroupName' => 'default', 'EC2SecurityGroupOwnerId' => @owner_id}).body
      returns("default") { body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["EC2SecurityGroupName"]}
      returns(@owner_id) { body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["EC2SecurityGroupOwnerId"]}
      returns("revoking") { body['RevokeDBSecurityGroupIngressResult']['DBSecurityGroup']['EC2SecurityGroups'][0]["Status"]}
      body
    end
    
    
    #TODO, authorize ec2 security groups
    
    tests("#delete_db_security_group").formats(AWS::RDS::Formats::BASIC) do
      body = Fog::AWS[:rds].delete_db_security_group(@sec_group_name).body
      
      raises(Fog::AWS::RDS::NotFound) {Fog::AWS[:rds].describe_db_security_groups(@sec_group_name)}

      body
    end
  end
end