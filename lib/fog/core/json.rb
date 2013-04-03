require 'singleton'
require 'fog/core/logger'

module Fog
  class JSON
    include Singleton

    class LoadError < StandardError
      attr_reader :data
      def initialize(message='', backtrace=[], data='')
        super(message)
        self.set_backtrace(backtrace)
        @data = data
      end
    end

    module LegacyJSON
      def encode(obj)
        ::JSON.generate(obj)
      end

      def decode(obj)
        ::JSON.parse(obj)
      rescue ::JSON::ParserError => e
        raise LoadError.new(e.message, e.backtrace, obj)
      end
    end

    module NewJSON
      def encode(obj)
        ::MultiJson.encode(obj)
      end

      def decode(obj)
        ::MultiJson.decode(obj)
      rescue MultiJson::LoadError => e
        raise LoadError.new(e.message, e.backtrace, obj)
      end
    end

    begin
      require 'multi_json'
      include NewJSON
    rescue Exception => e
      Fog::Logger.deprecation "Defaulting to json library for json parsing. Please consider using multi_json library for the greatest performance/flexibility."
      require 'json'
      include LegacyJSON
    end

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
      Fog::JSON.instance.encode(obj)
    end

    def self.decode(obj)
      Fog::JSON.instance.decode(obj)
    end
  end
end
