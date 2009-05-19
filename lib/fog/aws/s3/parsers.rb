require File.dirname(__FILE__) + '/../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class BasicParser < Fog::Parsers::Base

          attr_reader :result

          def initialize
            reset
          end

          def reset
            @result = {}
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
            @result = { :owner => {}, :buckets => [] }
          end

          def end_element(name)
            case name
            when 'Bucket'
              @result[:buckets] << @bucket
              @bucket = {}
            when 'CreationDate'
              @bucket[:creation_date] = @value
            when 'DisplayName'
              @result[:owner][:display_name] = @value
            when 'ID'
              @result[:owner][:id] = @value
            when 'Name'
              @bucket[:name] = @value
            end
          end

        end


      end
    end
  end
end
