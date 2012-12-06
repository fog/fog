Shindo.tests("Fog::Identity[:openstack] | ec2_credentials", ['openstack']) do
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
    tests('#find_by_access_key').succeeds do
      ec2_credential =
        @user.ec2_credentials.find_by_access_key(@ec2_credential.access)

      ec2_credential.access == @ec2_credential.access
    end

    tests('#create').succeeds do
      @user.ec2_credentials.create
    end

    tests('#destroy').succeeds do
      @user.ec2_credentials.destroy(@ec2_credential.access)
    end
  end

  tests('fails') do
    pending if Fog.mocking?

    tests('#find_by_access_key').raises(Fog::Identity::OpenStack::NotFound) do
      @user.ec2_credentials.find_by_access_key('fake')
    end

    tests('#destroy').raises(Fog::Identity::OpenStack::NotFound) do
      @user.ec2_credentials.destroy('fake')
    end
  end

end
