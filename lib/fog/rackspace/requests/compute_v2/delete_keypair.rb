module Fog
  module Compute
    class RackspaceV2
      class Real

        # Deletes the key specified with key_name
        #
        # ==== Parameters
        # * key_name<~String> - name of key to be deleted
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        def delete_keypair(key_name)
          request(
            :method   => 'DELETE',
            :expects  => 202,
            :path     => "/os-keypairs/#{key_name}"
          )
        end
      end

      class Mock
        def delete_keypair(name)
            if self.data[:keypairs].select { |k| name.include? k['keypair']['name'] }.empty?
                raise Fog::Compute::RackspaceV2::NotFound
            else
                self.data[:keypairs].reject! { |k| name.include? k['keypair']['name'] }
                response(:status => 202)
            end
        end
      end

    end
  end
end
