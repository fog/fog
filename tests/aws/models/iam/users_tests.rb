Shindo.tests("Fog::Compute[:iam] | users", ['aws','iam']) do

  Fog.mock!
  @iam = Fog::AWS[:iam]
  @user_one_name = 'fake_user_one'
  @user_two_name = 'fake_user_two'

  @user_three_name = 'fake_user_three'
  @user_three_path = '/path/to/fake_user_three/'
  @user_four_name = 'fake_user_four'

  tests('#create').succeeds do
    @user_one = @iam.users.create(:id => @user_one_name)
    @user_one.id == @user_one_name
  end

  tests('#all','there is only one user').succeeds do
    @iam.users.size == 1
  end
  
  tests('#all','the only user should match').succeeds do
    @iam.users.first.id == @user_one_name
  end
  
  tests('#create','a second user').succeeds do
    @user_two = @iam.users.create(:id => @user_two_name)
    @user_two.id == @user_two_name
  end  

  tests('#all','there are two users').succeeds do
    @iam.users.size == 2
  end

  tests('#get','an existing user').succeeds do
    @iam.users.get(@user_one_name).id == @user_one_name
  end

  tests('#get',"returns nil if the user doesn't exists").succeeds do
    @iam.users.get('non-exists') == nil
  end
  
  tests('#policies','it has no policies').succeeds do
    @iam.users.get(@user_one_name).policies.empty?
  end
  
  tests('#access_keys','it has no keys').succeeds do
    @iam.users.get(@user_one_name).access_keys.empty?
  end
  
  tests('#create', 'assigns path').succeeds do
    @user_three = @iam.users.create(:id => @user_three_name, :path => @user_three_path)
    @user_three.path == @user_three_path
  end

  tests('#create', 'defaults path to /').succeeds do
    @user_four = @iam.users.create(:id => @user_four_name)
    @user_four.path == '/'
  end

  tests('#destroy','an existing user').succeeds do
    @iam.users.get(@user_one_name).destroy
  end
  
  tests('#destroy','clean up remaining user').succeeds do
    @iam.users.get(@user_two_name).destroy
  end
  
end