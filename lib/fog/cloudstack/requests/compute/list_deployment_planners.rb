module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all DeploymentPlanners available.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listDeploymentPlanners.html]
        def list_deployment_planners(options={})
          options.merge!(
            'command' => 'listDeploymentPlanners'  
          )
          request(options)
        end
      end

    end
  end
end

