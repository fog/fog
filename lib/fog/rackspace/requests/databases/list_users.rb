require 'uri'

module Fog
  module Rackspace
    class Databases
      class Real

        def list_users(instance_id, prev=nil, path=nil)
          path ||= "instances/#{instance_id}/users"

          out = request(
            :expects => 200,
            :method => 'GET',
            :path => path
          )

          if prev && prev.data && out.data
            prev.data[:body]['users'].concat(out.data[:body]['users'])
            out.data[:body]['users'] = prev.data[:body]['users']
          end

          if out.body['links']
            out.body['links'].each do |l|
              if l['rel'] == "next"
                uri = URI(l['href'])
                out = list_users(instance_id, out, "instances/#{instance_id}/users?#{uri.query}")
              end
            end
          end

          out
        end
      end
    end
  end
end
