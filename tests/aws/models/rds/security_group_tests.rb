Shindo.tests("AWS::RDS | security_group", ['aws', 'rds']) do
  group_name = 'fog-test'
  params = {:id => group_name, :description => 'fog test'}

  model_tests(Fog::AWS[:rds].security_groups, params) do

    tests("#description").returns('fog test') { @instance.description }

    tests("#authorize_ec2_security_group").succeeds do
      @ec2_sec_group = Fog::Compute[:aws].security_groups.create(:name => 'fog-test', :description => 'fog test')

      @instance.authorize_ec2_security_group(@ec2_sec_group.name)
      returns('authorizing') do
        @instance.ec2_security_groups.find{|h| h['EC2SecurityGroupName'] == @ec2_sec_group.name}['Status']
      end
    end

    @instance.wait_for { ready? }

    tests("#revoke_ec2_security_group").succeeds do
      pending if Fog.mocking?

      @instance.revoke_ec2_security_group(@ec2_sec_group.name)

      returns('revoking') do
        @instance.ec2_security_groups.find{|h| h['EC2SecurityGroupName'] == @ec2_sec_group.name}['Status']
      end

      @instance.wait_for { ready? }

      returns(false) { @instance.ec2_security_groups.any?{|h| h['EC2SecurityGroupName'] == @ec2_sec_group.name} }
      @ec2_sec_group.destroy
    end

    tests("#authorize_cidrip").succeeds do
      @cidr = '127.0.0.1/32'
      @instance.authorize_cidrip(@cidr)
      returns('authorizing') { @instance.ip_ranges.find{|h| h['CIDRIP'] == @cidr}['Status'] }
    end

    tests("#revoke_cidrip").succeeds do
      pending if Fog.mocking?

      @instance.wait_for { ready? }
      @instance.revoke_cidrip(@cidr)
      returns('revoking') { @instance.ip_ranges.find{|h| h['CIDRIP'] == @cidr}['Status'] }
      @instance.wait_for { ready? }
      returns(false) { @instance.ip_ranges.any?{|h| h['CIDRIP'] == @cidr} }

    end

  end
end
