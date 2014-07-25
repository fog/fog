module Fog
    module Compute
        class ProfitBricks
            class Real
                require 'fog/profitbricks/parsers/compute/get_all_servers'
                def get_all_servers
                    soap_envelope = Fog::ProfitBricks.construct_envelope {
                      |xml| xml[:ws].getAllServers
                    }

                    request(
                        :expects => [200],
                        :method  => 'POST',
                        :body    => soap_envelope.to_xml,
                        :parser  => 
                          Fog::Parsers::Compute::ProfitBricks::GetAllServers.new
                    )
                end
            end

            class Mock
                def get_all_servers
                    if data = self.data[:servers]
                        response        = Excon::Response.new
                        response.status = 200
                        response.body   = {
                          'getAllServersResponse' => self.data[:servers]
                        }
                        response
                    else
                        raise Fog::Compute::NotFound
                    end
                end
            end
        end
    end
end