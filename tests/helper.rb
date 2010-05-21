require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog', 'bin'))

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

module Shindo
  class Tests

    def formats(format, &block)
      test('has proper format') do
        formats_kernel(instance_eval(&block), format)
      end
    end

    def succeeds(&block)
      test('succeeds') do
        begin
          instance_eval(&block)
          true
        rescue Exception, Interrupt
          false
        end
      end
    end

    private

    def formats_kernel(original_data, original_format, original = true)
      valid = true
      data = original_data.dup
      format = original_format.dup
      for key, value in format
        valid &&= data.has_key?(key)
        datum = data.delete(key)
        format.delete(key)
        case value
        when Array
          valid &&= datum.is_a?(Array)
          for element in datum
            type = value.first
            if type.is_a?(Hash)
              valid &&= formats_kernel({:element => element}, {:element => type}, false)
            else
              valid &&= element.is_a?(type)
            end
          end
        when Hash
          valid &&= datum.is_a?(Hash)
          valid &&= formats_kernel(datum, value, false)
        else
          valid &&= datum.is_a?(value)
        end
      end
      valid &&= data.empty? && format.empty?
      if !valid && original
        @message = "#{original_data.inspect} does not match #{original_format.inspect}"
      end
      valid
    end

  end
end
