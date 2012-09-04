require 'fog/core/collection'
require 'fog/aws/models/glacier/job'

module Fog
  module AWS
    class Glacier

      class Jobs < Fog::Collection

        model Fog::AWS::Glacier::Job
        attribute :vault

        def all
          data = connection.list_jobs(vault.id).body['JobList']
          load(data)
        end

        def get(key)
          data = connection.describe_job(vault.id, key).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :vault
          super({ :vault => vault }.merge!(attributes))
        end


      end

    end
  end
end
