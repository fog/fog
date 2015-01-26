require 'fog/core'
require 'fog/xml'

module Fog
  module VcloudDirector
    extend Fog::Provider

    module Errors
      class ServiceError < Fog::Errors::Error
        attr_reader :minor_error_code
        attr_reader :major_error_code
        attr_reader :stack_trace
        attr_reader :status_code
        attr_reader :vendor_specific_error_code

        def self.slurp(error, service=nil)
          major_error_code = nil
          message = nil
          minor_error_code = nil
          stack_trace = nil
          status_code = nil
          vendor_specific_error_code = nil

          if error.response
            status_code = error.response.status
            unless error.response.body.empty?
              _, media_type = error.response.headers.find {|k,v| k.downcase == 'content-type'}
              if media_type =~ /vnd\.vmware\.vcloud\.error\+xml/i
                begin
                  document = Fog::ToHashDocument.new
                  Nokogiri::XML::SAX::Parser.new(document).parse_memory(error.response.body)
                  major_error_code = document.body[:majorErrorCode]
                  message = document.body[:message]
                  minor_error_code = document.body[:minorErrorCode]
                  stack_trace = document.body[:stackTrace]
                  vendor_specific_error_code = document.body[:vendorSpecificErrorCode]
                rescue => e
                  Fog::Logger.warning("Received exception '#{e}' while decoding>> #{error.response.body}")
                  message = error.response.body
                end
              else
                message = CGI::unescapeHTML(error.response.body)
              end
            end
          end

          new_error = super(error, message)
          new_error.instance_variable_set(:@major_error_code, major_error_code)
          new_error.instance_variable_set(:@minor_error_code, minor_error_code)
          new_error.instance_variable_set(:@stack_trace, stack_trace)
          new_error.instance_variable_set(:@status_code, status_code)
          new_error.instance_variable_set(:@vendor_specific_error_code, vendor_specific_error_code)
          new_error
        end
      end

      class BadRequest < ServiceError; end
      class Unauthorized < ServiceError; end
      class Forbidden < ServiceError; end
      class Conflict < ServiceError; end
      class MalformedResponse < ServiceError; end

      class DuplicateName < ServiceError; end
      class TaskError < ServiceError; end
    end

    service(:compute, 'Compute')
  end
end
