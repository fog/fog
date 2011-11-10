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
[NilClass, Fog::Boolean].each {|klass| klass.send(:include, Fog::Nullable::Boolean)}
[NilClass, String].each {|klass| klass.send(:include, Fog::Nullable::String)}
[NilClass, Time].each {|klass| klass.send(:include, Fog::Nullable::Time)}
[Integer, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Integer)}
[Float, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Float)}
[Hash, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Hash)}
[Array, NilClass].each {|klass| klass.send(:include, Fog::Nullable::Array)}

module Shindo
  class Tests

    def formats(format, strict=true)
      raise ArgumentError, 'format is nil' unless format

      test('has proper format') do
        formats_kernel(instance_eval(&Proc.new), format, true, strict)
      end
    end

    private

    def formats_kernel(original_data, original_format, original = true, strict = true)
      valid = true
      data = original_data.dup
      format = original_format.dup
      if format.is_a?(Array)
        data   = {:element => data}
        format = {:element => format}
      end
      for key, value in format
        datum = data.delete(key)
        format.delete(key)
        case value
        when Array
          valid &&= datum.is_a?(Array) || p("#{key.inspect} not Array: #{datum.inspect}")
          if datum.is_a?(Array) && !value.empty?
            for element in datum
              type = value.first
              if type.is_a?(Hash)
                valid &&= formats_kernel({:element => element}, {:element => type}, false, strict)
              else
                valid &&= element.is_a?(type)
              end
            end
          end
        when Hash
          valid &&= datum.is_a?(Hash) || p("#{key.inspect} not Hash: #{datum.inspect}")
          valid &&= formats_kernel(datum, value, false, strict)
        else
          p "#{key.inspect} not #{value.inspect}: #{datum.inspect}" unless datum.is_a?(value)
          valid &&= datum.is_a?(value)
        end
      end
      p data unless data.empty?
      p format unless format.empty?
      if strict
        valid &&= data.empty? && format.empty?
      else
        valid &&= format.empty?
      end
      if !valid && original
        @message = "#{original_data.inspect} does not match #{original_format.inspect}"
      end
      valid
    end

  end
end
