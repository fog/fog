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
              @bucket[:creation_date] = @value
            when 'DisplayName'
              @response[:owner][:display_name] = @value
            when 'ID'
              @response[:owner][:id] = @value
            when 'Name'
              @bucket[:name] = @value
            end
          end

        end


      end
    end
  end
end
