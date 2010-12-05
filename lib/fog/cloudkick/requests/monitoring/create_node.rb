module Fog
  module Cloudkick
    class Monitoring
      class Real

        #FIXME: :details in the options doesn't work as documented at: 
        #https://support.cloudkick.com/API/2.0/Nodes#Creating_a_New_Node
        def create_node(options= {})
          query = options.map do |opt|
            if opt[1].is_a?(String)
              opt.join("=")
            else
              [opt[0],oauth_escape(opt[1].to_json)].join("=")
            end
          end.join("&")
          request(
            :headers  => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :expects  => [201],
            :method   => 'POST',
            :path     => "/#{API_VERSION}/nodes?#{query}",
            :body     => query
          )
        end

      end

      class Mock

        def create_node(options= {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
