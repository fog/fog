require 'fog/core/collection'
require 'fog/aws/models/beanstalk/environment'

module Fog
  module AWS
    class ElasticBeanstalk

      class Environments < Fog::Collection
        model Fog::AWS::ElasticBeanstalk::Environment

        def all(options={})
          data = connection.describe_environments(options).body['DescribeEnvironmentsResult']['Environments']
          load(data) # data is an array of attribute hashes
        end

        # Gets an environment given an id or name.
        #
        def get(environment_id)
          if match = environment_id.match(/e\-[a-zA-Z0-9]{10}/)
            options = { 'EnvironmentIds' => [environment_id] }
          else
            options = { 'EnvironmentNames' => [environment_id] }
          end

          if data = connection.describe_environments(options).body['DescribeEnvironmentsResult']['Environments'].first
            new(data)
          end
        end

      end
    end
  end
end
