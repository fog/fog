module Fog
  module Compute
    class IBM
      class Real

        # Get list of instances for a request
        #
        # ==== Parameters
        # * request_id<~String> - Id of request
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        # TODO: doc
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
