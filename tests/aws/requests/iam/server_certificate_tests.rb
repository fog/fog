Shindo.tests('AWS::IAM | server certificate requests', ['aws']) do

  pending if Fog.mocking?

  @key_name = 'fog-test'

  @upload_format = {
    'Certificate' => {
    'Arn' => String,
    'Path' => String,
    'ServerCertificateId' => String,
    'ServerCertificateName' => String,
    'UploadDate' => Time
  },
    'RequestId' => String
  }
  tests('#upload_server_certificate').formats(@upload_format) do
    public_key  = AWS::IAM::SERVER_CERT_PUBLIC_KEY
    private_key = AWS::IAM::SERVER_CERT_PRIVATE_KEY
    AWS[:iam].upload_server_certificate(public_key, private_key, @key_name).body
  end

  tests('#delete_server_certificate').formats(AWS::IAM::Formats::BASIC) do
    AWS[:iam].delete_server_certificate(@key_name).body
  end
end
