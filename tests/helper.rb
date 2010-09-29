require 'fog'
require 'fog/core/bin'
Fog.bin = true

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'model_helper'))

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# Boolean hax
module Fog
  module Boolean
  end
end
FalseClass.send(:include, Fog::Boolean)
TrueClass.send(:include, Fog::Boolean)

module Shindo
  class Tests

    def formats(format, &block)
      test('has proper format') do
        formats_kernel(instance_eval(&block), format)
      end
    end

    def succeeds(&block)
      test('succeeds') do
        instance_eval(&block)
        true
      end
    end

    private

    def formats_kernel(original_data, original_format, original = true)
      valid = true
      data = original_data.dup
      format = original_format.dup
      if format.is_a?(Array)
        data   = {:element => data}
        format = {:element => format}
      end
      for key, value in format
        valid &&= data.has_key?(key)
        datum = data.delete(key)
        format.delete(key)
        case value
        when Array
          valid &&= datum.is_a?(Array)
          if datum.is_a?(Array)
            for element in datum
              type = value.first
              if type.is_a?(Hash)
                valid &&= formats_kernel({:element => element}, {:element => type}, false)
              elsif type.nil?
                p "#{key} => #{value}"
              else
                valid &&= element.is_a?(type)
              end
            end
          end
        when Hash
          valid &&= datum.is_a?(Hash)
          valid &&= formats_kernel(datum, value, false)
        else
          p "#{key} => #{value}" unless datum.is_a?(value)
          valid &&= datum.is_a?(value)
        end
      end
      p data unless data.empty?
      p format unless format.empty?
      valid &&= data.empty? && format.empty?
      if !valid && original
        @message = "#{original_data.inspect} does not match #{original_format.inspect}"
      end
      valid
    end

  end
end
