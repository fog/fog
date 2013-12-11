require 'fog/core/collection'
require 'fog/aws/models/rds/log_file'

module Fog
  module AWS
    class RDS

      class LogFiles < Fog::Collection
        attribute :filters
        attribute :rds_id
        model Fog::AWS::RDS::LogFile

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        # This method deliberately returns only a single page of results
        def all(filters=filters)
          self.filters.merge!(filters)

          result = service.describe_db_log_files(rds_id, self.filters).body['DescribeDBLogFilesResult']
          self.filters[:marker] = result['Marker']
          load(result['DBLogFiles'])
        end

        def each(filters=filters)
          if block_given?
            begin
              page = self.all(filters)
              # We need to explicitly use the base 'each' method here on the page, otherwise we get infinite recursion
              base_each = Fog::Collection.instance_method(:each)
              base_each.bind(page).call { |log_file| yield log_file }
            end while self.filters[:marker]
          end
          self
        end

        def get(file_name=nil)
          if file_name
            matches = self.select {|log_file| log_file.name.upcase == file_name.upcase}
            return matches.first unless matches.empty?
          end
        rescue Fog::AWS::RDS::NotFound
        end

      end
    end
  end
end
