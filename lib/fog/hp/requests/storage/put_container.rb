module Fog
  module Storage
    class HP
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name, options = {})
          response = request(
            :expects  => [201, 202],
            :headers  => options,
            :method   => 'PUT',
            :path     => Fog::HP.escape(name)
          )
          response
        end

      end

      class Mock # :nodoc:all
        def put_container(container_name, options = {})
          acl = options['X-Container-Read'] || 'private'
          if !['private', 'public-read'].include?(acl)
            #raise Excon::Errors::BadRequest.new('invalid X-Container-Read')
          else
            self.data[:acls][:container][container_name] = self.class.acls(acl)
          end

          response = Excon::Response.new
          container = {
            :objects        => {},
          }
          if self.data[:containers][container_name]
            response.status = 202
          else
            response.status = 201
            self.data[:containers][container_name] = container
          end
          response
        end
      end

    end
  end
end
