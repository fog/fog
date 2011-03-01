module Fog
  module AWS
    class IAM
      class Real

        require 'fog/aws/parsers/iam/upload_server_certificate'

        # Uploads a server certificate entity for the AWS Account.
        # Includes a public key certificate, a private key, and an optional certificate chain, which should all be PEM-encoded.
        #
        # ==== Parameters
        # * certificate<~Hash>: The contents of the public key certificate in PEM-encoded format.
        # * private_key<~Hash>: The contents of the private key in PEM-encoded format.
        # * name<~Hash>: The name for the server certificate. Do not include the path in this value.
        # * options<~Hash>:
        #   * 'CertificateChain'<~String> - The contents of the certificate chain. Typically a concatenation of the PEM-encoded public key certificates of the chain.
        #   * 'Path'<~String> - The path for the server certificate.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'UploadServerCertificateResult'<~Hash>:
        #       * 'CertificateId'<~String> -
        #       * 'UserName'<~String> -
        #       * 'CertificateBody'<~String> -
        #       * 'Status'<~String> -
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_UploadServerCertificate.html
        #
        def upload_server_certificate(certificate, private_key, name, options = {})
          request({
            'Action'                => 'UploadServerCertificate',
            'CertificateBody'       => certificate,
            'PrivateKey'            => private_key,
            'ServerCertificateName' => name,
            :parser                 => Fog::Parsers::AWS::IAM::UploadServerCertificate.new
          }.merge!(options))
        end

      end
    end
  end
end
