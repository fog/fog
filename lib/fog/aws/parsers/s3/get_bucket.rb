module Fog
  module Parsers
    module AWS
      module S3

        class GetBucket < Fog::Parsers::Base

          def reset
            @object = { :owner => {} }
            @response = { :contents => [] }
          end

          def end_element(name)
            case name
            when 'Contents'
              @response[:contents] << @object
              @object = { :owner => {} }
            when 'Delimeter'
              @object[:delimiter] = @value
            when 'DisplayName'
              @object[:owner][:display_name] = @value
            when 'ETag'
              @object[:etag] = @value
            when 'ID'
              @object[:owner][:id] = @value
            when 'IsTruncated'
              if @value == 'true'
                @response[:is_truncated] = true
              else
                @response[:is_truncated] = false
              end
            when 'Key'
              @object[:key] = @value
            when 'LastModified'
              @object[:last_modified] = Time.parse(@value)
            when 'Marker'
              @response[:marker] = @value
            when 'MaxKeys'
              @response[:max_keys] = @value.to_i
            when 'Name'
              @response[:name] = @value
            when 'Prefix'
              @response[:prefix] = @value
            when 'Size'
              @object[:size] = @value.to_i
            when 'StorageClass'
              @object[:storage_class] = @value
            end
          end

        end

      end
    end
  end
end
