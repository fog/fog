module Fog
  module Compute
    class RackspaceV2
      class Real

        # Requests a new keypair to be created
        #
        # ==== Parameters
        # * name<~String> - name to give new key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * keypair<~Hash>:
        #     * 'fingerprint'<~String>: 
        #     * 'name'<~String>: 
        #     * 'private_key'<~String>: 
        #     * 'public_key'<~String>: 
        #     * 'user_id'<~String>: 
        def create_keypair(name, public_key=nil)
          data = {
            'keypair' => {
              'name' => name
            }
          }

          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/os-keypairs',
            :body     => Fog::JSON.encode(data)
          )
        end
      end

      class Mock
        def create_keypair(name, public_key=nil)
            # 409 response when already existing
            raise Fog::Compute::RackspaceV2::ServiceError if not self.data[:keypairs].select { |k| name.include? k['keypair']['name'] }.first.nil?

            k = self.data[:keypair]
            k['name'] = name
            self.data[:keypairs] << { 'keypair' => k }

            response( :status => 200,
                      :body   => { 'keypair' => k } )
        end
      end

    end
  end
end
