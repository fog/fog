Shindo.tests('AWS::IAM | server certificate requests', ['aws']) do
  @key_name = 'fog-test'

  @certificate_format = {
  'Arn' => String,
  'Path' => String,
  'ServerCertificateId' => String,
  'ServerCertificateName' => String,
  'UploadDate' => Time
  }
  @upload_format = {
    'Certificate' => @certificate_format,
    'RequestId' => String
  }

  tests('#upload_server_certificate') do
    public_key  = AWS::IAM::SERVER_CERT_PUBLIC_KEY
    private_key = AWS::IAM::SERVER_CERT_PRIVATE_KEY
    private_key_mismatch = AWS::IAM::SERVER_CERT_PRIVATE_KEY_MISMATCHED

    tests('empty public key').raises(Fog::AWS::IAM::ValidationError) do
      Fog::AWS[:iam].upload_server_certificate('', private_key, @key_name)
    end

    tests('empty private key').raises(Fog::AWS::IAM::ValidationError) do
      Fog::AWS[:iam].upload_server_certificate(public_key, '', @key_name)
    end

    tests('invalid public key').raises(Fog::AWS::IAM::MalformedCertificate) do
      Fog::AWS[:iam].upload_server_certificate('abcde', private_key, @key_name)
    end

    tests('invalid private key').raises(Fog::AWS::IAM::MalformedCertificate) do
      Fog::AWS[:iam].upload_server_certificate(public_key, 'abcde', @key_name)
    end

    tests('mismatched private key').raises(Fog::AWS::IAM::KeyPairMismatch) do
      Fog::AWS[:iam].upload_server_certificate(public_key, private_key_mismatch, @key_name)
    end

    tests('format').formats(@upload_format) do
      Fog::AWS[:iam].upload_server_certificate(public_key, private_key, @key_name).body
    end

    tests('duplicate name').raises(Fog::AWS::IAM::EntityAlreadyExists) do
      Fog::AWS[:iam].upload_server_certificate(public_key, private_key, @key_name)
    end
  end

  tests('#get_server_certificate').formats(@upload_format) do
    tests('raises NotFound').raises(Fog::AWS::IAM::NotFound) do
      Fog::AWS[:iam].get_server_certificate("#{@key_name}fake")
    end
    Fog::AWS[:iam].get_server_certificate(@key_name).body
  end

  @list_format = { 'Certificates' => [@certificate_format] }
  tests('#list_server_certificates').formats(@list_format) do
    result = Fog::AWS[:iam].list_server_certificates.body
    tests('includes key name') do
      returns(true) { result['Certificates'].any?{|c| c['ServerCertificateName'] == @key_name} }
    end
    result
  end

  tests('#delete_server_certificate').formats(AWS::IAM::Formats::BASIC) do
    Fog::AWS[:iam].delete_server_certificate(@key_name).body
  end
end
