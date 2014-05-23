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
          requested_fqdn = options['fqdn'] || options[:fqdn]
          request(
            :expects  => 200,
            :idempotent => true,
            :method   => :get,
            :path     => ['AllRecord', zone, requested_fqdn].compact.join('/')
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
            data = data | zone[:records].map { |type, records| records.select { |record| record[:fqdn] == fqdn } }.flatten.compact
          else
            data = data | zone[:records].map { |type, records| records.map { |record| record[:fqdn] } }.flatten
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
