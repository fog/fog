module Fog
  module Compute
    class RackspaceV2
      class Real
        # Delete the key specified with key_name
        # @param  [String] key_name name of the key to delete
        # @return [Excon::Response] response
        # @raise  [Fog::Compute::RackspaceV2::NotFound]
        # @raise  [Fog::Compute::RackspaceV2::BadRequest]
        # @raise  [Fog::Compute::RackspaceV2::InternalServerError]
        # @raise  [Fog::Compute::RackspaceV2::ServiceError]
        # @see    http://docs.rackspace.com/servers/api/v2/cs-devguide/content/DeleteKeyPair.html
        def delete_keypair(key_name)
          request(
            :method   => 'DELETE',
            :expects  => 202,
            :path     => "/os-keypairs/#{URI.escape(key_name)}"
          )
        end
      end

      class Mock
        def delete_keypair(key_name)
            if self.data[:keypairs].select { |k| key_name.include? k['keypair']['name'] }.empty?
                raise Fog::Compute::RackspaceV2::NotFound
            else
                self.data[:keypairs].reject! { |k| key_name.include? k['keypair']['name'] }
                response(:status => 202)
            end
        end
      end
    end
  end
end
