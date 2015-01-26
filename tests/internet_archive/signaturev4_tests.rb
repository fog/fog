# encoding: utf-8

Shindo.tests('InternetArchive | signaturev4', ['internetarchive']) do

  # These testcases are from http://docs.amazonwebservices.com/general/latest/gr/signature-v4-test-suite.html
  @signer = Fog::InternetArchive::SignatureV4.new('AKIDEXAMPLE', 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY', 'us-east-1','host')

  Fog::Time.now = ::Time.utc(2011,9,9,23,36,0)

  tests('get-vanilla') do
    returns(@signer.sign({:headers => {'Host' => 'host.foo.com', 'Date' => 'Mon, 09 Sep 2011 23:36:00 GMT'}, :method => :get, :path => '/'}, Fog::Time.now)) do
      'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=b27ccfbfa7df52a200ff74193ca6e32d4b48b8856fab7ebf1c595d0670a7e470'
    end
  end

  tests('get-vanilla-query-order-key with symbol keys') do
    returns(@signer.sign({:query => {:'a' => 'foo', :'b' => 'foo'}, :headers => {:'Host' => 'host.foo.com', 'Date' => 'Mon, 09 Sep 2011 23:36:00 GMT'}, :method => :get, :path => '/'}, Fog::Time.now)) do
      'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=0dc122f3b28b831ab48ba65cb47300de53fbe91b577fe113edac383730254a3b'
    end
  end

  tests('get-vanilla-query-order-key') do
    returns(@signer.sign({:query => {'a' => 'foo', 'b' => 'foo'}, :headers => {'Host' => 'host.foo.com', 'Date' => 'Mon, 09 Sep 2011 23:36:00 GMT'}, :method => :get, :path => '/'}, Fog::Time.now)) do
      'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=0dc122f3b28b831ab48ba65cb47300de53fbe91b577fe113edac383730254a3b'
    end
  end

  tests('get-unreserved') do
    returns(@signer.sign({:headers => {'Host' => 'host.foo.com', 'Date' => 'Mon, 09 Sep 2011 23:36:00 GMT'}, :method => :get, :path => '/-._~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'}, Fog::Time.now)) do
      'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=date;host, Signature=830cc36d03f0f84e6ee4953fbe701c1c8b71a0372c63af9255aa364dd183281e'
    end
  end

  tests('post-x-www-form-urlencoded-parameter') do
    returns(@signer.sign({:headers => {'Content-type' => 'application/x-www-form-urlencoded; charset=utf8', 'Host' => 'host.foo.com', 'Date' => 'Mon, 09 Sep 2011 23:36:00 GMT'}, :method => :post, :path => '/',
                          :body => 'foo=bar'}, Fog::Time.now)) do
      'AWS4-HMAC-SHA256 Credential=AKIDEXAMPLE/20110909/us-east-1/host/aws4_request, SignedHeaders=content-type;date;host, Signature=b105eb10c6d318d2294de9d49dd8b031b55e3c3fe139f2e637da70511e9e7b71'
    end
  end
  Fog::Time.now = ::Time.now
end
