module Fog
  module Parsers
    module AWS
      module RDS

        class DescribeDBLogFiles < Fog::Parsers::Base

          def reset
            @response = { 'DescribeDBLogFilesResult' => {'DBLogFiles' => []}, 'ResponseMetadata' => {} }
            @db_log_file = {}
          end

          def start_element(name, attrs = [])
            super
          end

          def end_element(name)
            case name
            when 'LastWritten' then @db_log_file['LastWritten'] = Time.at(value.to_i / 1000)
            when 'LogFileName' then @db_log_file['LogFileName'] = value
            when 'Size' then @db_log_file['Size'] = value.to_i
            when 'DescribeDBLogFilesDetails'
              @response['DescribeDBLogFilesResult']['DBLogFiles'] << @db_log_file
              @db_log_file = {}
            when 'Marker'
              @response['DescribeDBLogFilesResult']['Marker'] = value
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
