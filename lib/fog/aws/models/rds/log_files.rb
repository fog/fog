require 'fog/core/collection'
require 'fog/aws/models/rds/log_file'

module Fog
  module AWS
    class RDS

      class LogFiles < Fog::Collection
        attribute :rds_id
        model Fog::AWS::RDS::LogFile

        def all
          data = service.describe_db_log_files(rds_id).body['DescribeDBLogFilesResult']['DBLogFiles']
          load(data) # data is an array of attribute hashes
        end

        def get(file_name=nil)
          data = service.describe_db_log_files(rds_id, {:filename_contains => file_name}).body['DescribeDBLogFilesResult']['DBLogFiles'].first
          new(data) # data is an attribute hash
        rescue Fog::AWS::RDS::NotFound
          nil
        end

      end
    end
  end
end
