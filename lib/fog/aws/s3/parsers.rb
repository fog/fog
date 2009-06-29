require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class BasicParser < Fog::Parsers::Base

          attr_reader :response

          def initialize
            reset
          end

          def reset
            @response = {}
          end

          def characters(string)
            @value << string.strip
          end

          def start_element(name, attrs = [])
            @value = ''
          end

        end

        class GetServiceParser < Fog::Parsers::AWS::S3::BasicParser

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

        class GetBucketParser < Fog::Parsers::AWS::S3::BasicParser

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
              @response[:is_truncated] = @value
            when 'Key'
              @object[:key] = @value
            when 'LastModified'
              @object[:last_modified] = @value
            when 'Marker'
              @response[:marker] = @value
            when 'MaxKeys'
              @response[:max_keys] = @value
            when 'Name'
              @response[:name] = @value
            when 'Prefix'
              @response[:prefix] = @value
            when 'Size'
              @object[:size] = @value
            when 'StorageClass'
              @object[:storage_class] = @value
            end
          end

        end

        class GetRequestPayment < Fog::Parsers::AWS::S3::BasicParser

          def end_element(name)
            case name
            when 'Payer'
              @response[:payer] = @value
            end
          end

        end

        class GetBucketLocation < Fog::Parsers::AWS::S3::BasicParser

          def end_element(name)
            case name
            when 'LocationConstraint'
              @response[:location_constraint] = @value
            end
          end

        end

      end
    end
  end
end
