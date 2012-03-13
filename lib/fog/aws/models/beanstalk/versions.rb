require 'fog/core/collection'
require 'fog/aws/models/beanstalk/version'

module Fog
  module AWS
    class ElasticBeanstalk

      class Versions < Fog::Collection
        model Fog::AWS::ElasticBeanstalk::Version

        def all(options={})
          data = connection.describe_application_versions(options).body['DescribeApplicationVersionsResult']['ApplicationVersions']
          load(data) # data is an array of attribute hashes
        end

        def get(application_name, version_label)
          if data = connection.describe_application_versions([application_name]).body['DescribeApplicationVersionsResult']['ApplicationVersions'].first
            new(data)
          end
        end

      end
    end
  end
end
