module Fog
  module DNS
    class Dynect
      class Real

        # Get one or more node lists
        #
        # ==== Parameters
        # * zone<~String> - zone to lookup node lists for
        # * options<~Hash>
        #   * fqdn<~String> - fully qualified domain name of node to lookup

        def get_node_list(zone, options = {})
          request(
            :expects  => 200,
            :method   => :get,
            :path     => ['NodeList', zone, options['fqdn']].compact.join('/')
          )
        end
      end

      class Mock
        def get_node_list(zone, options = {})
          raise Fog::DNS::Dynect::NotFound unless zone = self.data[:zones][zone]

          response = Excon::Response.new
          response.status = 200

          data = [zone[:zone]]

          if fqdn = options[:fqdn]
            data = data | zone[:records].collect { |type, records| records.select { |record| record[:fqdn] == fqdn } }.flatten.compact
          else
            data = data | zone[:records].collect { |type, records| records.collect { |record| record[:fqdn] } }.flatten
          end

          response.body = {
            "status" => "success",
            "data" => data,
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "INFO" => "get_tree: Here is your zone tree",
              "SOURCE" => "BLL",
              "ERR_CD" => nil,
              "LVL" => "INFO"
            }]
          }

          response
        end
      end
    end
  end
end
