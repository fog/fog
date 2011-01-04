require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')
require 'fog/core/bin'

# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = ['aws', 'bluebox', 'brightbox', 'gogrid', 'google', 'linode', 'local', 'newservers', 'rackspace', 'slicehost', 'terremark']
available_providers = Fog.providers.map {|provider| provider.to_s.downcase}
for provider in (all_providers - available_providers)
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '~/.fog' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end

# format related hackery
# allows both true.is_a?(Fog::Boolean) and false.is_a?(Fog::Boolean)
# allows both nil.is_a?(Fog::Nullable::String) and ''.is_a?(Fog::Nullable::String)
module Fog
  module Boolean; end
  module Nullable
    module String; end
  end
end

[FalseClass, TrueClass].each {|klass| klass.send(:include, Fog::Boolean)}
[NilClass, String].each {|klass| klass.send(:include, Fog::String)}

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
