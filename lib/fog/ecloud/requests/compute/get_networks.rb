module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_networks
      end

      class Mock
        def get_networks(uri)
          environment_id = id_from_uri(uri)
          environment = self.data[:environments][environment_id]

          networks = self.data[:networks].values.select{|n| n[:environment_id] == environment_id}.dup
          networks = networks.map{|n| Fog::Ecloud.slice(n, :environment, :id)}

          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.network; type=collection",
            :Links => {
              :Link => Fog::Ecloud.keep(environment, :name, :href, :type)
            },
            :Network => (networks.size > 1 ? networks : networks.first),
          }

          response(:body =>  body)
        end
      end
    end
  end
end
