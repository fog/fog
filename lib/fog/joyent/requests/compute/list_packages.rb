module Fog
  module Compute
    class Joyent

      class Mock
        def list_packages
          response = Excon::Response.new()
          response.status = 200
          response.body = self.data[:packages].values
          response
        end
      end

      class Real
        # Lists all the packages available to the authenticated user
        # ==== Returns
        # Exon::Response<Array>
        # * name<~String> The "friendly name for this package
        # * memory<~Number> How much memory will by available (in Mb)
        # * disk<~Number> How much disk space will be available (in Gb)
        # * swap<~Number> How much swap memory will be available (in Mb)
        # * default<~Boolean> Whether this is the default package in this datacenter"
        #
        def list_packages
          request(
            :path => "/my/packages",
            :method => "GET",
            :expects => 200
          )
        end
      end # Real

    end

  end
end
