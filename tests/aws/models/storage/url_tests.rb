# encoding: utf-8

Shindo.tests('AWS | url', ["aws"]) do


  @storage = Fog::Storage.new(
    :provider => 'AWS',
    :aws_access_key_id => '123',
    :aws_secret_access_key => 'abc',
    :region => 'us-east-1'
  )

  @file = @storage.directories.new(:key => 'fognonbucket').files.new(:key => 'test.txt')

  now = Fog::Time.now
  if RUBY_VERSION > '1.8.7' # ruby 1.8.x doesn't provide hash ordering
    tests('#url w/ response-cache-control').returns(
      "https://fognonbucket.s3.amazonaws.com/test.txt?response-cache-control=No-cache&X-Amz-Expires=500&X-Amz-Date=#{now.to_iso8601_basic}&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=123/#{now.utc.strftime('%Y%m%d')}/us-east-1/s3/aws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature="
    ) do

      @file.url(Time.now + 500, :query => { 'response-cache-control' => 'No-cache' }).gsub(/(X-Amz-Signature=)[0-9a-f]+\z/,'\\1')
    end
  end


end
