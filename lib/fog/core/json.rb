begin
  require 'multi_json'
  $multiJsonExists = true
rescue LoadError
   $multiJsonExists = false
end

begin
  require 'json'
  $jsonExists = true
rescue LoadError
  $jsonExists = false
end


if not $multiJsonExists and not $jsonExists
    raise RuntimeError, "either multi_json or json library must be installed"
end


module Fog
  module JSON

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

    if $multiJsonExists
      if MultiJson.respond_to?(:dump)
        def self.encode(obj)
          MultiJson.dump(obj)
        end
      else
        def self.encode(obj)
          MultiJson.encode(obj)
        end
      end

      if MultiJson.respond_to?(:load)
        def self.decode(obj)
          MultiJson.load(obj)
        end
      else
        def self.decode(obj)
          MultiJson.decode(obj)
        end
      end
    else
      def self.encode(obj)
        ::JSON.generate(obj)
      end

      def self.decode(obj)
        ::JSON.parse(obj)
      end
    end
  end
end
