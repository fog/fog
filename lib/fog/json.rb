require "multi_json"

module Fog

  # @note Extracting JSON components out of core is a work in progress.
  #
  # The {JSON} module includes functionality that is common between APIs using
  # JSON to send and receive data.
  #
  # The intent is to provide common code for provider APIs using JSON but not
  # require it for those using XML.
  #
  module JSON
    class EncodeError < Fog::Errors::Error; end
    class DecodeError < Fog::Errors::Error; end

    def self.sanitize(data)
      case data
      when Array
        data.map {|datum| sanitize(datum)}
      when Hash
        for key, value in data
          data[key] = sanitize(value)
        end
      when ::Time
        data.strftime("%Y-%m-%dT%H:%M:%SZ")
      else
        data
      end
    end

    # Do the MultiJson introspection at this level so we can define our encode/decode methods and perform
    # the introspection only once rather than once per call.

    def self.encode(obj)
      MultiJson.encode(obj)
    rescue => err
      raise EncodeError.slurp(err)
    end

    def self.decode(obj)
      MultiJson.decode(obj)
    rescue => err
      raise DecodeError.slurp(err)
    end
  end
end
