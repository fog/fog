module Fog
  module Compute
    class Cloudstack

      class Real
        # Upgrades router to use newer template
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/upgradeRouterTemplate.html]
        def upgrade_router_template(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'upgradeRouterTemplate') 
          else
            options.merge!('command' => 'upgradeRouterTemplate')
          end
          request(options)
        end
      end

    end
  end
end

