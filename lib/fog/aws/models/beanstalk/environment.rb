require 'fog/core/model'

module Fog
  module AWS
    class ElasticBeanstalk

      class Environment < Fog::Model
        identity :id, :aliases => 'EnvironmentId'

        attribute :application_name, :aliases => 'ApplicationName'
        attribute :cname, :aliases => 'CNAME'
        attribute :cname_prefix, :aliases => 'CNAMEPrefix'
        attribute :created_at, :aliases => 'DateCreated'
        attribute :updated_at, :aliases => 'DateUpdated'
        attribute :updated_at, :aliases => 'DateUpdated'
        attribute :description, :aliases => 'Description'
        attribute :endpoint_url, :aliases => 'EndpointURL'
        attribute :name, :aliases => 'EnvironmentName'
        attribute :health, :aliases => 'Health'
        attribute :resources, :aliases => 'Resources'
        attribute :solution_stack_name, :aliases => 'SolutionStackName'
        attribute :status, :aliases => 'Status'
        attribute :template_name, :aliases => 'TemplateName'
        attribute :version_label, :aliases => 'VersionLabel'

        def healthy?
          health == 'Green'
        end

        def ready?
          status == 'Ready'
        end

        def destroy
          requires :id
          connection.terminate_environment({'EnvironmentId' => id})
          true
        end

        def save
          requires :name, :application_name
          requires_one :template_name, :solution_stack_name

          options = {
              'ApplicationName' => application_name,
              #'CNAMEPrefix' => cname_prefix,
              #'Description' => description,
              'EnvironmentName' => name
          }

          options['SolutionStackName'] = solution_stack_name unless solution_stack_name.nil?
          options['TemplateName'] = template_name unless template_name.nil?

          pp options

          data = connection.create_environment(options).body['CreateEnvironmentResult']
          merge_attributes(data)
          true
        end

      end

    end
  end
end