# encoding: utf-8

Shindo.tests('AWS | url', ["aws"]) do

  @expires = Time.utc(2013,1,1).utc.to_i

  @storage = Fog::Storage.new(
    :provider => 'AWS',
    :aws_access_key_id => '123',
    :aws_secret_access_key => 'abc',
    :region => 'us-east-1'
  )
  
  @file = @storage.directories.new(:key => 'fognonbucket').files.new(:key => 'test.txt')

  if Fog.mock?
    signature = Fog::Storage::AWS.new.signature(nil, nil)
  else
    signature = 'tajHIhKHAdFYsigmzybCpaq8N0Q%3D'
  end

  if RUBY_VERSION > '1.8.7' # ruby 1.8.x doesn't provide hash ordering
    tests('#url w/ response-cache-control').returns(
      "https://fognonbucket.s3.amazonaws.com/test.txt?response-cache-control=No-cache&AWSAccessKeyId=123&Signature=#{signature}&Expires=1356998400"
    ) do
      @file.url(@expires, :query => { 'response-cache-control' => 'No-cache' })
    end
  end

end
