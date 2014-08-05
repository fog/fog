# encoding: utf-8

Shindo.tests('InternetArchive | url', ["internetarchive"]) do

  @expires = Time.utc(2013,1,1).utc.to_i

  @storage = Fog::Storage.new(
    :provider => 'InternetArchive',
    :ia_access_key_id => '123',
    :ia_secret_access_key => 'abc',
    :region => 'us-east-1'
  )

  @file = @storage.directories.new(:key => 'fognonbucket').files.new(:key => 'test.txt')

  if Fog.mock?
    signature = Fog::Storage::InternetArchive.new.signature(nil)
  else
    signature = 'tajHIhKHAdFYsigmzybCpaq8N0Q%3D'
  end

  tests('#url w/ response-cache-control').returns(
    "http://fognonbucket.s3.us.archive.org/test.txt?response-cache-control=No-cache&AWSAccessKeyId=123&Signature=#{signature}&Expires=1356998400"
  ) do
    @file.url(@expires, :query => { 'response-cache-control' => 'No-cache' })
  end

end
