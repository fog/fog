require "fog/parser"

module Fog
  module Errors
    class Continue < StandardError; end # 100
    class SwitchingProtocols < StandardError; end # 101
    class OK < StandardError; end # 200
    class Created < StandardError; end # 201
    class Accepted < StandardError; end # 202
    class NonAuthoritativeInformation < StandardError; end # 203
    class NoContent < StandardError; end # 204
    class ResetContent < StandardError; end # 205
    class PartialContent < StandardError; end # 206
    class MultipleChoices < StandardError; end # 300
    class MovedPermanently < StandardError; end # 301
    class Found < StandardError; end # 302
    class SeeOther < StandardError; end # 303
    class NotModified < StandardError; end # 304
    class UseProxy < StandardError; end # 305
    class TemporaryRedirect < StandardError; end # 307
    class BadRequest < StandardError; end # 400
    class Unauthorized < StandardError; end # 401
    class PaymentRequired < StandardError; end # 402
    class Forbidden < StandardError; end # 403
    class NotFound < StandardError; end # 404
    class MethodNotAllowed < StandardError; end # 405
    class NotAcceptable < StandardError; end #406
    class ProxyAuthenticationRequired < StandardError; end #407
    class RequestTimeout < StandardError; end # 408
    class Conflict < StandardError; end # 409
    class Gone < StandardError; end # 410
    class LengthRequired < StandardError; end # 411
    class PreconditionFailed < StandardError; end # 412
    class RequestEntityTooLarge < StandardError; end # 412
    class RequestURITooLong < StandardError; end # 414
    class UnsupportedMediaType < StandardError; end # 415
    class RequestedRangeNotSatisfiable < StandardError; end # 416
    class ExpectationFailed < StandardError; end # 417
    class InternalServerError < StandardError; end # 500
    class NotImplemented < StandardError; end # 501
    class BadGateway < StandardError; end # 502
    class ServiceUnavailable < StandardError; end # 503
    class GatewayTimeout < StandardError; end # 504

    # Messages for nicer exceptions, from rfc2616
    def self.status_error(expected, actual, response)
      @errors ||= { 
        100 => Fog::Errors::Continue, 
        101 => Fog::Errors::SwitchingProtocols,
        200 => Fog::Errors::OK,
        201 => Fog::Errors::Created,
        202 => Fog::Errors::Accepted,
        203 => Fog::Errors::NonAuthoritativeInformation,
        204 => Fog::Errors::NoContent,
        205 => Fog::Errors::ResetContent,
        206 => Fog::Errors::PartialContent,
        300 => Fog::Errors::MultipleChoices,
        301 => Fog::Errors::MovedPermanently,
        302 => Fog::Errors::Found,
        303 => Fog::Errors::SeeOther,
        304 => Fog::Errors::NotModified,
        305 => Fog::Errors::UseProxy,
        307 => Fog::Errors::TemporaryRedirect,
        400 => Fog::Errors::BadRequest,
        401 => Fog::Errors::Unauthorized,
        402 => Fog::Errors::PaymentRequired,
        403 => Fog::Errors::Forbidden,
        404 => Fog::Errors::NotFound,
        405 => Fog::Errors::MethodNotAllowed,
        406 => Fog::Errors::NotAcceptable,
        407 => Fog::Errors::ProxyAuthenticationRequired,
        408 => Fog::Errors::RequestTimeout,
        409 => Fog::Errors::Conflict,
        410 => Fog::Errors::Gone,
        411 => Fog::Errors::LengthRequired,
        412 => Fog::Errors::PreconditionFailed,
        413 => Fog::Errors::RequestEntityTooLarge,
        414 => Fog::Errors::RequestURITooLong,
        415 => Fog::Errors::UnsupportedMediaType,
        416 => Fog::Errors::RequestedRangeNotSatisfiable,
        417 => Fog::Errors::ExpectationFailed,
        500 => Fog::Errors::InternalServerError,
        501 => Fog::Errors::NotImplemented,
        502 => Fog::Errors::BadGateway,
        503 => Fog::Errors::ServiceUnavailable,
        504 => Fog::Errors::GatewayTimeout
      }
      @messages ||= { 
        100 => 'Continue', 
        101 => 'Switching Protocols',
        200 => 'OK',
        201 =>'Created',
        202 => 'Accepted',
        203 => 'Non-Authoritative Information',
        204 => 'No Content',
        205 => 'Reset Content',
        206 => 'Partial Content',
        300 => 'Multiple Choices',
        301 => 'Moved Permanently',
        302 => 'Found',
        303 => 'See Other',
        304 => 'Not Modified',
        305 => 'Use Proxy',
        307 => 'Temporary Redirect',
        400 => 'Bad Request',
        401 => 'Unauthorized',
        402 => 'Payment Required',
        403 => 'Forbidden',
        404 => 'Not Found',
        405 => 'Method Not Allowed',
        406 => 'Not Acceptable',
        407 => 'Proxy Authentication Required',
        408 => 'Request Timeout',
        409 => 'Conflict',
        410 => 'Gone',
        411 => 'Length Required',
        412 => 'Precondition Failed',
        413 => 'Request Entity Too Large',
        414 => 'Request-URI Too Long',
        415 => 'Unsupported Media Type',
        416 => 'Requested Range Not Satisfiable',
        417 => 'Expectation Failed',
        500 => 'Internal Server Error',
        501 => 'Not Implemented',
        502 => 'Bad Gateway',
        503 => 'Service Unavailable',
        504 => 'Gateway Timeout'
      }
      response = "#{response.body['Code']} => #{response.body['Message']}"
      @errors[actual].new("Expected(#{expected} #{@messages[expected]}) <=> Actual(#{actual} #{@messages[actual]}): #{response}")
    end

    class Parser < Fog::Parsers::Base

      def end_element(name)
        case name
        when 'Code', 'Message'
          @response[name] = @value
        end
      end

    end

  end
end