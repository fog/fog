module Fog
  module Compute
    class IBM
      class Real
        # Returns list of instances created with request specified by request_id
        #
        # ==== Parameters
        # * request_id<~String> - Id of request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #   * instances<~Array>: array of instances created with request
        #     * 'name'<~String>: instance name
        #     * 'location'<~String>: instance location id
        #     * 'keyName'<~String>: instance assigned keypair
        #     * 'primaryIP'<~Hash>: assigned ip address, type, and hostname
        #     * 'productCodes'<~Array>: associated product codes
        #     * 'requestId'<~String>:
        #     * 'imageId'<~String>:
        #     * 'launchTime'<~Integer>: UNIX time integer representing when the instance was launched
        #     * 'id'<~String>: instance id
        #     * 'volumes'<~Array>:
        #     * 'isMiniEphemeral'<~Boolean>: minimal local storage
        #     * 'instanceType'<~String>: instance type
        #     * 'diskSize'<~String>: instance disk size
        #     * 'requestName'<~String>: instance request name
        #     * 'secondaryIP'<~Array>: additional IP Addresses associated with this instance
        #     * 'status'<~Integer>: instance status flag
        #     * 'software'<~Array>: Software associated with this instance
        #       * 'application'<~Hash>: Application name, type, and version (primarily OS information)
        #     * 'expirationTime'<~Integer>: UNIX timestamp representing when the instance expires
        #     * 'owner'<~String>: instance owner
        def get_request(request_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "computecloud/enterprise/api/rest/20100331/requests/#{request_id}"
          )
        end
      end

      class Mock
        def get_request(request_id)
          response = Excon::Response.new
          response.status = 200
          response.body =  {"instances"=>
             [{"name"=>"test from fog",
               "location"=>"101",
               "keyName"=>"mykey",
               "primaryIP"=>
                {"type"=>0, "ip"=>"42.42.42.42 ", "hostname"=>"42.42.42.42 "},
               "productCodes"=>[],
               "requestId"=>"75364",
               "imageId"=>"20020159",
               "launchTime"=>1304012220770,
               "id"=>"75064",
               "volumes"=>[],
               "instanceType"=>"SLV32.2/4096/60*350",
               "requestName"=>"test from fog",
               "secondaryIP"=>[],
               "status"=>1,
               "software"=>
                [{"name"=>"SUSE Linux Enterprise Server",
                  "type"=>"OS",
                  "version"=>"11 SP1"}],
               "expirationTime"=>1367084229205,
               "owner"=>"user@example.com"}]}
          response
        end
      end
    end
  end
end
