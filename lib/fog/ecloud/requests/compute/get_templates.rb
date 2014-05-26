module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_templates
      end

      class Mock
        def get_templates(uri) # /cloudapi/ecloud/computepools/compute_pools/534
          compute_pool_id = id_from_uri(uri)
          compute_pool    = self.data[:compute_pools][compute_pool_id]

          templates = self.data[:templates].values.select{|template| template[:compute_pool_id] == compute_pool_id}
          templates = templates.map{|template| Fog::Ecloud.slice(template, :id, :compute_pool)}

          template_response = {:Template => (templates.size > 1 ? templates : templates.first)} # GAH
          body = {
            :href  => uri,
            :type  => "application/vnd.tmrk.cloud.template; type=collection",
            :Links => {
              :Link => compute_pool,
            },
            :Families => {
              :Family => {
                :Name => "Standard Templates",
                :Categories => {
                  :Category => [
                    {
                      :Name => "OS Only",
                      :OperatingSystems => {
                        :OperatingSystem => {
                          :Name => "Linux",
                          :Templates => template_response,
                        }
                      }
                    }
                  ]
                }
              }
            }
          }

          response(:body => body)
        end
      end
    end
  end
end
