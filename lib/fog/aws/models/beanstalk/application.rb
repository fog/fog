require 'fog/core/model'

module Fog
  module AWS
    class ElasticBeanstalk

      class Application < Fog::Model
        identity :name, :aliases => 'ApplicationName'
        attribute :template_names, :aliases => 'ConfigurationTemplates'
        attribute :created_at, :aliases => 'DateCreated'
        attribute :updated_at, :aliases => 'DateUpdated'
        attribute :description, :aliases => 'Description'
        attribute :version_names, :aliases => 'Versions'

        def initialize(attributes={})
          super
        end

        def environments
          requires :name
          connection.environments.all({'ApplicationName' => name})
        end

        def events
          requires :name
          connection.events.all({'ApplicationName' => name})
        end

        def templates
          requires :name
          connection.templates.all({'ApplicationName' => name})
        end

        def versions
          requires :name
          connection.versions.all({'ApplicationName' => name})
        end

        def destroy
          requires :name
          connection.delete_application(name)
          true
        end

        def save
          requires :name

          options = {
              'ApplicationName' => name
          }
          options['Description'] = description unless description.nil?

          data = connection.create_application(options).body['CreateApplicationResult']['Application']
          merge_attributes(data)
          true
        end

      end

    end
  end
end