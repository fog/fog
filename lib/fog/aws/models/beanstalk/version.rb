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

      end

    end
  end
end