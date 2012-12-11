Shindo.tests("Fog::Identity[:openstack] | ec2_credential", ['openstack']) do
  before do
    openstack = Fog::Identity[:openstack]
    tenant_id = openstack.list_tenants.body['tenants'].first['id']

    @user = openstack.users.find { |user| user.name == 'foobar' }
    @user ||= openstack.users.create({
      :name      => 'foobar',
      :email     => 'foo@bar.com',
      :tenant_id => tenant_id,
      :password  => 'spoof',
      :enabled   => true
    })

    @ec2_credential = openstack.ec2_credentials.create({
      :user_id   => @user.id,
      :tenant_id => tenant_id,
    })
  end

  after do
    @user.ec2_credentials.each do |ec2_credential|
      ec2_credential.destroy
    end

    @user.destroy
  end

  tests('success') do
    tests('#destroy').returns(true) do
      @ec2_credential.destroy
    end
  end

  tests('failure') do
    tests('#save').raises(Fog::Errors::Error) do
      @ec2_credential.save
    end
  end

end
