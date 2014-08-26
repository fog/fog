module Fog
  module Compute
    class Cloudstack

      class Real
        # Upgrades router to use newer template
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/upgradeRouterTemplate.html]
        def upgrade_router_template(options={})
          request(options)
        end


        def upgrade_router_template(options={})
          options.merge!(
            'command' => 'upgradeRouterTemplate'  
          )
          request(options)
        end
      end

    end
  end
end

