module Fog
  module AWS
    class IAM
      class Real
        # Updates the name and/or the path of the specified server certificate.
        #
        # ==== Parameters
        # * server_certificate_name<~String> - The name of the server
        #   certificate that you want to update.
        # * options<~Hash>:
        #   * 'NewPath'<~String> - The new path for the server certificate.
        #     Include this only if you are updating the server certificate's
        #     path.
        #   * 'NewServerCertificateName'<~String> - The new name for the server
        #     certificate. Include this only if you are updating the server
        #     certificate's name.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'RequestId'<~String> - Id of the request
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/IAM/latest/APIReference/index.html?API_UpdateServerCertificate.html
        #
        def update_server_certificate(server_certificate_name, options = {})
          request({
            'Action'                => 'UpdateServerCertificate',
            'ServerCertificateName' => server_certificate_name,
            :parser                 => Fog::Parsers::AWS::IAM::Basic.new
          }.merge!(options))
        end

      end
    end
  end
end
