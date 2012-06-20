require 'fakeweb'
Shindo.tests('AWS | credentials', ['aws']) do
  default_credentials = Fog::Compute::AWS.fetch_credentials({})
  FakeWeb.clean_registry
  FakeWeb.register_uri(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/", :body => 'arole')

  expires_at = Time.at(Time.now.to_i + 500)
  credentials = {
    'AccessKeyId' => 'dummykey',
    'SecretAccessKey' => 'dummysecret',
    'Token' => 'dummytoken',
    'Expiration' => expires_at.xmlschema
  }

  FakeWeb.register_uri(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/arole", :body => Fog::JSON.encode(credentials))


  tests("#fetch_credentials") do
    returns({:aws_access_key_id => 'dummykey', 
              :aws_secret_access_key => 'dummysecret', 
              :aws_session_token => 'dummytoken', 
              :aws_credentials_expire_at => expires_at}) { Fog::Compute::AWS.fetch_credentials(:use_iam_profile => true) }
  end

  compute = Fog::Compute::AWS.new(:use_iam_profile => true)

  tests("#refresh_credentials_if_expired") do
    returns(nil){compute.refresh_credentials_if_expired}
  end

  credentials['AccessKeyId'] = 'newkey'
  credentials['SecretAccessKey'] = 'newsecret'
  credentials['Expiration'] = (expires_at + 10).xmlschema

  FakeWeb.register_uri(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/arole", :body => Fog::JSON.encode(credentials))

  Fog::Time.now = expires_at + 1
  tests("#refresh_credentials_if_expired") do
    returns(true){compute.refresh_credentials_if_expired}
    returns("newkey"){ compute.instance_variable_get(:@aws_access_key_id)}
  end


  tests("#fetch_credentials when the url 404s") do
    FakeWeb.register_uri(:get, "http://169.254.169.254/latest/meta-data/iam/security-credentials/", :body => '', :status => [404, 'Not found'])
    returns(default_credentials) {Fog::Compute::AWS.fetch_credentials(:use_iam_profile => true)}
  end


  FakeWeb.clean_registry
  Fog::Time.now = Time.now
end
