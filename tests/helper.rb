require 'fog'
require 'fog/core/bin'
Fog.bin = true

__DIR__ = File.dirname(__FILE__)

$LOAD_PATH.unshift __DIR__ unless
  $LOAD_PATH.include?(__DIR__) ||
  $LOAD_PATH.include?(File.expand_path(__DIR__))

require 'tests/helpers/collection_tests'
require 'tests/helpers/model_tests'

require 'tests/helpers/compute/flavors_tests'
require 'tests/helpers/compute/server_tests'
require 'tests/helpers/compute/servers_tests'

require 'tests/helpers/storage/directory_tests'
require 'tests/helpers/storage/directories_tests'
require 'tests/helpers/storage/file_tests'
require 'tests/helpers/storage/files_tests'

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

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

module Shindo
  class Tests

    def responds_to(method_names)
      for method_name in [*method_names]
        tests("#respond_to?(:#{method_name})").succeeds do
          @instance.respond_to?(method_name)
        end
      end
    end

    def formats(format)
      test('has proper format') do
        formats_kernel(instance_eval(&Proc.new), format)
      end
    end

    def succeeds
      test('succeeds') do
        instance_eval(&Proc.new)
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
