# format related hackery
# allows both true.is_a?(Fog::Boolean) and false.is_a?(Fog::Boolean)
# allows both nil.is_a?(Fog::Nullable::String) and ''.is_a?(Fog::Nullable::String)
module Fog
  module Boolean; end
  module Nullable
    module Boolean; end
    module Integer; end
    module String; end
    module Time; end
    module Float; end
    module Hash; end
    module Array; end
  end
end
[FalseClass, TrueClass].each {|klass| klass.send(:include, Fog::Boolean)}
[FalseClass, TrueClass, NilClass, Fog::Boolean].each {|klass| klass.send(:include, Fog::Nullable::Boolean)}
[NilClass, String].each {|klass| klass.send(:include, Fog::Nullable::String)}
[NilClass, Time].each {|klass| klass.send(:include, Fog::Nullable::Time)}
[Integer, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Integer)}
[Float, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Float)}
[Hash, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Hash)}
[Array, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Array)}

module Shindo
  class Tests

    # Generates a Shindo test that compares a hash schema to the result
    # of the passed in block returning true if they match.
    #
    # The schema that is passed in is a Hash or Array of hashes that
    # have Classes in place of values. When checking the schema the
    # value should match the Class.
    #
    # Strict mode will fail if the data has additional keys. Setting
    # +strict+ to +false+ will allow additional keys to appear.
    #
    # @param [Hash] schmea A Hash schema
    # @param [Hash] options Options to change validation rules
    # @option options [Boolean] :allow_extra_keys
    #     If +true+ deoes not fail when keys are in the data that are
    #     not specified in the schema. This allows new values to
    #     appear in API output without breaking the check.
    # @option options [Boolean] :allow_optional_rules
    #     If +true+ does not fail if extra keys are in the schema
    #     that do not match the data. Not recommended!
    # @yield Data to check with schema
    #
    # @example Using in a test
    #     Shindo.tests("data matches schema") do
    #       data = {:string => "Hello" }
    #       data_matches_schema(:string => String) { data }
    #     end
    #
    #     data matches schema
    #       + has proper format
    #
    # @example Example schema
    #     {
    #       "id" => String,
    #       "ram" => Integer,
    #       "disks" => [
    #         "size" => Float
    #       ],
    #       "dns_name" => Fog::Nullable::String,
    #       "active" => Fog::Boolean,
    #       "created" => DateTime
    #     }
    #
    # @return [Boolean]
    def data_matches_schema(schema, options = {})
      test('data matches schema') do
        confirm_data_matches_schema(yield, schema, options)
      end
    end

    # @deprecation #formats is deprecated. Use #data_matches_schema instead
    def formats(format, strict = true)
      test('has proper format') do
        if strict
          options = {:allow_extra_keys => false, :allow_optional_rules => true}
        else
          options = {:allow_extra_keys => true, :allow_optional_rules => true}
        end
        confirm_data_matches_schema(yield, format, options)
      end
    end

    private

    # Checks if the data structure matches the schema passed in and
    # returns true if it fits.
    #
    # @param [Object] data Hash or Array to check
    # @param [Object] schema Schema pattern to check against
    # @param [Boolean] options
    # @option options [Boolean] :allow_extra_keys
    #     If +true+ does not fail if extra keys are in the data
    #     that are not in the schema. Allows
    # @option options [Boolean] :allow_optional_rules
    #     If +true+ does not fail if extra keys are in the schema
    #     that do not match the data. Not recommended!
    #
    # @return [Boolean] Did the data fit the schema?
    def confirm_data_matches_schema(data, schema, options = {})
      # Clear message passed to the Shindo tests
      @message = nil

      valid = validate_value(schema, data, options)

      unless valid
        @message = "#{data.inspect} does not match #{schema.inspect}"
      end
      valid
    end

    # This contains a slightly modified version of the Hashidator gem
    # but unfortunately the gem does not cope with Array schemas.
    #
    # @see https://github.com/vangberg/hashidator/blob/master/lib/hashidator.rb
    #
    def validate_value(validator, value, options)
      Fog::Logger.write :debug, "[yellow][DEBUG] #{value.inspect} against #{validator.inspect}[/]\n"

      # When being strict values not specified in the schema are fails
      unless options[:allow_extra_keys]
        if validator.respond_to?(:empty?) && value.respond_to?(:empty?)
          # Validator is empty but values are not
          return false if !value.empty? && validator.empty?
        end
      end

      unless options[:allow_optional_rules]
        if validator.respond_to?(:empty?) && value.respond_to?(:empty?)
          # Validator has rules left but no more values
          return false if value.empty? && !validator.empty?
        end
      end

      case validator
      when Array
        return false if value.is_a?(Hash)
        value.respond_to?(:all?) && value.all? {|x| validate_value(validator[0], x, options)}
      when Symbol
        value.respond_to? validator
      when Hash
        return false if value.is_a?(Array)
        validator.all? do |key, sub_validator|
          Fog::Logger.write :debug, "[blue][DEBUG] #{key.inspect} against #{sub_validator.inspect}[/]\n"
          validate_value(sub_validator, value[key], options)
        end
      else
        result = validator == value
        result = validator === value unless result
        # Repeat unless we have a Boolean already
        unless (result.is_a?(TrueClass) || result.is_a?(FalseClass))
          result = validate_value(result, value, options)
        end
        if result
          Fog::Logger.write :debug, "[green][DEBUG] Validation passed: #{value.inspect} against #{validator.inspect}[/]\n"
        else
          Fog::Logger.write :debug, "[red][DEBUG] Validation failed: #{value.inspect} against #{validator.inspect}[/]\n"
        end
        result
      end
    end
  end
end
