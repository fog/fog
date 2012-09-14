# encoding: utf-8

Shindo.tests('AWS | signed_params', ['aws']) do
  tests('escape') do
    returns( Fog::AWS.escape( "'Stöp!' said Fred_-~." ) ) { "%27St%C3%B6p%21%27%20said%20Fred_-~." }
  end

  Fog::Time.now = ::Time.utc(2011,9,9,23,36,0)
  @hmac = Fog::HMAC.new('sha256', 'dummy secret')

  tests('sign-https-default-port') do
    returns("AWSAccessKeyId=access_key_id&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-09-09T23%3A36%3A00Z&Version=2012-07-20&Signature=nCiUaPWcupQpQS2tPGVa3RsYUlrHWF2eDaO%2FMXppcAY%3D") do
      Fog::AWS.signed_params( 
        {"Action"=>"DescribeInstances"},
        {:aws_access_key_id=>"access_key_id", :aws_session_token=>nil, :hmac=>@hmac, :host=>"dns.name.com", :path=>"/", :port=>443, :scheme=>"https", :version=>"2012-07-20"})
    end
  end

  tests('sign-http-default-port') do
    returns ("AWSAccessKeyId=access_key_id&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-09-09T23%3A36%3A00Z&Version=2012-07-20&Signature=nCiUaPWcupQpQS2tPGVa3RsYUlrHWF2eDaO%2FMXppcAY%3D") do
      Fog::AWS.signed_params( 
        {"Action"=>"DescribeInstances"},
        {:aws_access_key_id=>"access_key_id", :aws_session_token=>nil, :hmac=>@hmac, :host=>"dns.name.com", :path=>"/", :port=>80, :scheme=>"http", :version=>"2012-07-20"})
    end
  end

  tests('sign-http-non-default-port') do
    returns ("AWSAccessKeyId=access_key_id&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-09-09T23%3A36%3A00Z&Version=2012-07-20&Signature=SgkyhLq5vY7UVaeWUQak8RERBAnzzqpEf243%2BNColDA%3D") do
      Fog::AWS.signed_params( 
        {"Action"=>"DescribeInstances"},
        {:aws_access_key_id=>"access_key_id", :aws_session_token=>nil, :hmac=>@hmac, :host=>"dns.name.com", :path=>"/", :port=>8080, :scheme=>"http", :version=>"2012-07-20"})
    end
  end

  tests('sign with port when schema is missing') do
    returns ("AWSAccessKeyId=access_key_id&Action=DescribeInstances&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-09-09T23%3A36%3A00Z&Version=2012-07-20&Signature=iec8K2opwYSiQi4smpJcKVLHFcV5A0Kxaf9QXeVtelU%3D") do
      Fog::AWS.signed_params( 
        {"Action"=>"DescribeInstances"},
        {:aws_access_key_id=>"access_key_id", :aws_session_token=>nil, :hmac=>@hmac, :host=>"dns.name.com", :path=>"/", :port=>443, :version=>"2012-07-20"})
    end
  end
end
