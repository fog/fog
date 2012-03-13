module Fog
  module AWS
    class ElasticBeanstalk
      class Real

        require 'fog/aws/parsers/beanstalk/describe_application_versions'

        # Deletes the specified application along with all associated versions and configurations.
        #
        # ==== Options
        # * application_name<~String>: The name of the application to delete releases from.
        # * version_label<~String>: The label of the version to delete.
        # * delete_source_bundle<~Boolean>: Indicates whether to delete the associated source bundle from Amazon S3.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #
        # ==== See Also
        # http://docs.amazonwebservices.com/elasticbeanstalk/latest/api/API_DeleteApplication.html
        #
        def describe_application_versions(options={})
          if version_labels = options.delete('VersionLabels')
            options.merge!(AWS.indexed_param('VersionLabels.member.%d', [*version_labels]))
          end
          request({
                      'Operation'    => 'DescribeApplicationVersions',
                      :parser     => Fog::Parsers::AWS::ElasticBeanstalk::DescribeApplicationVersions.new
                  }.merge(options))
        end
      end
    end
  end
end
