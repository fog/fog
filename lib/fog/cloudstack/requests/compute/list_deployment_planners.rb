module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all DeploymentPlanners available.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listDeploymentPlanners.html]
        def list_deployment_planners(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listDeploymentPlanners') 
          else
            options.merge!('command' => 'listDeploymentPlanners')
          end
          request(options)
        end
      end

    end
  end
end

