module Fog
  module DNS
    class Rage4
      class Real

        # Get the details for a specific domain in your account.
        # ==== Parameters
        # * id<~String> - name of domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'id'<~Integer>
        #      * 'name'<~String>
        #      * 'owner_email'<~String>
        #      * 'type'<~Integer>
        #      * 'subnet_mask'<~Integer>
        def get_domain_by_name(name)
          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => "/rapi/getdomainbyname/?name=#{name}")

        end

      end

      class Mock

        def get_domain_by_name(name)
          domain = self.data[:domains].detect do |domain|
            domain["domain"]["name"] == id
          end
          response = Excon::Response.new
          response.status = 200
          response.body = domain
          response
        end

      end

    end
  end
end
