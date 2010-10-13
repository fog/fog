module Fog
  module Parsers
    module Google
      module Storage

        class GetBucket < Fog::Parsers::Base

          def reset
            @object = { 'Owner' => {} }
            @response = { 'Contents' => [] }
          end

          def end_element(name)
            case name
            when 'Contents'
              @response['Contents'] << @object
              @object = { 'Owner' => {} }
            when 'DisplayName', 'ID'
              @object['Owner'][name] = @value
            when 'ETag'
              @object[name] = @value.gsub('"', '')
            when 'IsTruncated'
              if @value == 'true'
                @response['IsTruncated'] = true
              else
                @response['IsTruncated'] = false
              end
            when 'LastModified'
              @object['LastModified'] = Time.parse(@value)
            when 'Marker', 'Name', 'Prefix'
              @response[name] = @value
            when 'MaxKeys'
              @response['MaxKeys'] = @value.to_i
            when 'Size'
              @object['Size'] = @value.to_i
            when 'Delimeter', 'Key', 'StorageClass'
              @object[name] = @value
            end
          end

        end

      end
    end
  end
end
