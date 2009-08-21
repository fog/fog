unless Fog.mocking?

  module Fog
    module AWS
      class EC2

        # Create a new key pair
        #
        # ==== Parameters
        # * key_name<~String> - Unique name for key pair.
        #
        # ==== Returns
        # * response<~Fog::AWS::Response>:
        #   * body<~Hash>:
        #     * 'keyFingerprint'<~String> - SHA-1 digest of DER encoded private key
        #     * 'keyMaterial'<~String> - Unencrypted encoded PEM private key
        #     * 'keyName'<~String> - Name of key
        #     * 'requestId'<~String> - Id of request
        def create_key_pair(key_name)
          request({
            'Action' => 'CreateKeyPair',
            'KeyName' => key_name
          }, Fog::Parsers::AWS::EC2::CreateKeyPair.new)
        end

      end
    end
  end

else

  module Fog
    module AWS
      class EC2

        def create_key_pair(key_name)
          response = Fog::Response.new
          unless Fog::AWS::EC2.data[:key_pairs][key_name]
            response.status = 200
            data = {
              'keyFingerprint'  => Fog::AWS::Mock.key_fingerprint,
              'keyMaterial'     => Fog::AWS::Mock.key_material,
              'keyName'         => key_name
            }
            Fog::AWS::EC2.data[:key_pairs][key_name] = data
            response.body = {
              'requestId' => Fog::AWS::Mock.request_id
            }.merge!(data)
          else
            response.status = 400
            raise(Fog::Errors.status_error(200, 400, response))
          end
          response
        end

      end
    end
  end

end
