require File.dirname(__FILE__) + '/../../../parser'

module Fog
  module Parsers
    module AWS
      module S3

        class GetService < Fog::Parsers::Base

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

      end
    end
  end
end
