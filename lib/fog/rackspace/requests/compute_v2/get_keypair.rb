module Fog
  module Compute
    class RackspaceV2
      class Real

        # Returns details of key by name specified
        #
        # ==== Parameters
        # 'key_name'<~String>: name of key to request
        #         
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash>: Name of key
        #       * 'public_key'<~String>: public key
        #       * 'name'<~String>: key name
        #       * 'fingerprint'<~String>: id
        #
        def get_keypair(key_name)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def get_keypair(name)
            key = self.data[:keypairs].select { |k| name.include? k['keypair']['name'] }.first
            if key.nil?
                raise Fog::Compute::RackspaceV2::NotFound
            end

            response(:body => key, :status => 200)
        end
      end

    end
  end
end
