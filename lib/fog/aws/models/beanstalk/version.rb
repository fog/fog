require 'fog/core/model'

module Fog
  module AWS
    class ElasticBeanstalk

      class Version < Fog::Model
        identity :label, :aliases => 'VersionLabel'
        attribute :application_name, :aliases => 'ApplicationName'
        attribute :created_at, :aliases => 'DateCreated'
        attribute :updated_at, :aliases => 'DateUpdated'
        attribute :description, :aliases => 'Description'
        attribute :source_bundle, :aliases => 'SourceBundle'

        def destroy
          requires :application_name, :label
          connection.delete_application_versions(application_name, label)
          true
        end

        def save
          requires :name
          data = connection.create_application_version(name, description).body['CreateApplicationVersionResult']['ApplicationVersion']
          merge_attributes(data)
          true
        end

      end

    end
  end
end