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
          read_h  = options['X-Container-Read']  || ''
          write_h = options['X-Container-Write'] || ''
          unless options
            read_acl, write_acl = self.class.header_to_perm_acl(read_h, write_h)
            self.data[:acls][:container][container_name] = {:read_acl => read_acl, :write_acl => write_acl}
          end

          response = Excon::Response.new
          container = {
            :objects  => {}
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
