module Fog
  module Compute
    class Google
      class Mock
        def insert_firewall(firewall_name, allowed, network = GOOGLE_COMPUTE_DEFAULT_NETWORK, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_firewall(firewall_name, allowed, network = GOOGLE_COMPUTE_DEFAULT_NETWORK, options = {})
          unless network.start_with? 'http'
            network = "#{@api_url}#{@project}/global/networks/#{network}"
          end

          api_method = @compute.firewalls.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            "name" => firewall_name,
            "network" => network,
            "allowed" => allowed,
          }
          unless options[:description].nil?
            body_object["description"] = options[:description]
          end
          unless options[:source_ranges].nil? || options[:source_ranges].empty?
            body_object["sourceRanges"] = options[:source_ranges]
          end
          unless options[:source_tags].nil? || options[:source_tags].empty?
            body_object["sourceTags"] = options[:source_tags]
          end
          unless options[:target_tags].nil? || options[:target_tags].empty?
            body_object["targetTags"] = options[:target_tags]
          end

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
