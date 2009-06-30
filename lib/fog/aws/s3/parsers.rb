require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class GetServiceParser < Fog::Parsers::Base

          def reset
            @bucket = {}
            @response = { :owner => {}, :buckets => [] }
          end

          def end_element(name)
            case name
            when 'Bucket'
              @response[:buckets] << @bucket
              @bucket = {}
            when 'CreationDate'
              @bucket[:creation_date] = Time.parse(@value)
            when 'DisplayName'
              @response[:owner][:display_name] = @value
            when 'ID'
              @response[:owner][:id] = @value
            when 'Name'
              @bucket[:name] = @value
            end
          end

        end

        class GetBucketParser < Fog::Parsers::Base

          def reset
            @object = { :owner => {} }
            @response = { :contents => [] }
          end

          def end_element(name)
            case name
            when 'Contents'
              @response[:contents] << @object
              @object = { :owner => {} }
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

        class GetRequestPayment < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'Payer'
              @response[:payer] = @value
            end
          end

        end

        class GetBucketLocation < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'LocationConstraint'
              @response[:location_constraint] = @value
            end
          end

        end

        class CopyObject < Fog::Parsers::Base

          def end_element(name)
            case name
            when 'ETag'
              @response[:etag] = @value
            when 'LastModified'
              @response[:last_modified] = Time.parse(@value)
            end
          end

        end

      end
    end
  end
end
