# encoding: utf-8

Shindo.tests('AWS | url') do

  @expires = DateTime.parse('2013-01-01T00:00:00Z').to_time.utc.to_i

  @storage = Fog::Storage.new(
    provider: 'AWS',
    aws_access_key_id: '123',
    aws_secret_access_key: 'abc',
    region: 'us-east-1'
  )
  
  @file = @storage.directories.new(key: 'fognonbucket').files.new(key: 'test.txt')

  tests('#url w/ response-cache-control').returns(
    'https://fognonbucket.s3.amazonaws.com/test.txt?response-cache-control=No-cache&AWSAccessKeyId=123&Signature=tajHIhKHAdFYsigmzybCpaq8N0Q%3D&Expires=1356998400'
  ) do
    @file.url(@expires, query: { 'response-cache-control' => 'No-cache' })
  end

end
