module Fog
  module Compute
    class Joyent
      class Mock
        #
        # https://us-west-1.api.joyentcloud.com/docs#CreateKey
        #
        def create_key(params)
          name = params[:name]
          key = params[:key]

          record = {
            "name" => name,
            "key" => key,
            "created" => Time.now.utc,
            "updated" => Time.now.utc
          }

          self.data[:keys][name] = record

          response = Excon::Response.new
          response.status = 201
          response.body = record
          response
        end
      end # Mock

      class Real
        # Creates a new SSH Key
        # ==== Parameters
        # * name<~String> - Name to assign to this key
        # * key<~String> - OpenSSH formatted public key
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'name'<~String> - Name for this key
        #     * 'key'<~String> - OpenSSH formatted public key
        #
        def create_key(params={})
          raise ArgumentError, "error creating key: [name] is required" unless params[:name]
          raise ArgumentError, "error creating key: [key] is required" unless params[:key]

          request(
            :method => "POST",
            :path => "/my/keys",
            :body => { "name" => params[:name], "key" => params[:key] },
            :expects => 201
          )
        end
      end
    end
  end
end
