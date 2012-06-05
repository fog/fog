Shindo.tests("Fog::Compute[:iam] | policies", ['aws','iam']) do

  Fog.mock!
  iam = Fog::AWS[:iam]
  
  @username = 'fake_user'
  @users = iam.users.create(:id => @username)
  @policy_document = {"Statement"=>[{"Action"=>["sqs:*"], "Effect"=>"Allow", "Resource"=>"*"}]}
  @policy_name = 'fake-sqs-policy'
  
  tests('#all', 'there is no policies').succeeds do
    @users.policies.empty?
  end
  
  
  tests('#create','a policy').succeeds do
    policy = @users.policies.create(id: @policy_name, document: @policy_document)
    policy.id == @policy_name
    policy.username == @username
    #policy.document == @policy_document # FIXME, the format isn't right
  end
  
  @users.policies.create(id: 'another-policy', document: {})
  
  tests('#all','there are two policies').succeeds do
    @users.policies.size == 2
  end
  
  tests('#get') do
    tests('a valid policy').succeeds do
      policy = @users.policies.get(@policy_name)
      policy.id == @policy_name
      policy.username == @username
      #policy.document == @policy_document # FIXME, the format isn't right    
    end
    
    tests('an invalid policy').succeeds do
      @users.policies.get('non-existing') == nil
    end
  end
  
  tests('#destroy').succeeds do
    @users.policies.get(@policy_name).destroy
  end
  

  
end