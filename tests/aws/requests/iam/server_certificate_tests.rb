Shindo.tests('AWS::IAM | server certificate requests', ['aws']) do

  pending if Fog.mocking?

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
  tests('#upload_server_certificate').formats(@upload_format) do
    public_key  = AWS::IAM::SERVER_CERT_PUBLIC_KEY
    private_key = AWS::IAM::SERVER_CERT_PRIVATE_KEY
    AWS[:iam].upload_server_certificate(public_key, private_key, @key_name).body
  end

  @list_format = { 'Certificates' => [@certificate_format] }
  tests('#list_server_certificates').formats(@list_format) do
    result = AWS[:iam].list_server_certificates.body
    tests('includes key name') do
      returns(true) { result['Certificates'].any?{|c| c['ServerCertificateName'] == @key_name} }
    end
    result
  end

  tests('#delete_server_certificate').formats(AWS::IAM::Formats::BASIC) do
    AWS[:iam].delete_server_certificate(@key_name).body
  end
end
