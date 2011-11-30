module Fog
  module Compute
    class HP
      class Real

        # Create a new security group
        #
        # ==== Parameters
        # * name<~String> - name of the security group
        # * description<~String> - description of the security group
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'keypair'<~Hash> - The keypair data
        #       * 'public_key'<~String> - The public key for the keypair
        #       * 'private_key'<~String> - The private key for the keypair
        #       * 'user_id'<~String> - The user id
        #       * 'fingerprint'<~String> - SHA-1 digest of DER encoded private key
        #       * 'name'<~String> - Name of key
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def create_security_group(name, description)
          data = {
            'security_group' => {
              'name'       => name,
              'description' => description || "#{name} security group"
            }
          }

          request(
            :body     => MultiJson.encode(data),
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-security-groups.json'
          )
        end

      end

      class Mock

        def create_security_group(name, description)
          response = Excon::Response.new
          unless self.data[:security_groups][name]
            response.status = 200
            data = {
              'id'           => Fog::Mock.random_numbers(3),
              'name'         => name,
              'description'  => description || "#{name} security group",
              'tenant_id'    => Fog::HP::Mock.user_id,
              'rules'        => []
            }
            self.data[:last_modified][:security_groups][name] = Time.now
            self.data[:security_groups][name] = data

            response.body = { 'security_group' => data }
            response
          else
            raise Fog::Compute::HP::Error.new("InvalidSecurityGroup.Duplicate => The security group '#{name}' already exists")
          end
        end

      end

    end
  end
end
