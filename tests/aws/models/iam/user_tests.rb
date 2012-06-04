Shindo.tests("Fog::Compute[:iam] | user", ['aws','iam']) do

  Fog.mock!
  @iam = Fog::AWS[:iam]
  @user_one_name = 'fake_user_one'
  @user_two_name = 'fake_user_two'
  
  tests('#create').succeeds do
    @user_one = @iam.users.create(:id => @user_one_name)
    @user_one.id == @user_one_name
  end
  #@user_two = @iam.users.create(:id => 'fake_user_two')
  
  tests('#users','there is only one user').succeeds do
    @iam.users.size == 1
  end
  
  tests('#users','the only user should match').succeeds do
    @iam.users.first.id == @user_one_name
  end
  
  tests('#create','a second user').succeeds do
    @user_two = @iam.users.create(:id => @user_two_name)
    @user_two.id == @user_two_name
  end  

  tests('#users','there are two users').succeeds do
    @iam.users.size == 2
  end

  tests('#get','an existing user').succeeds do
    @iam.users.get(@user_one_name).id == @user_one_name
  end

  tests('#get','nil if the user doesnt exists').succeeds do
    @iam.users.get('non-exists') == nil
  end
  
  tests('#policies').succeeds do
    
  end
  
  tests('#access_keys').succeeds do
    
  end
  
  tests('#destroy','an existing user').succeeds do
    @iam.users.get(@user_one_name).destroy
  end
  
end