require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'fog', 'bin'))

# TODO: Currently is true even if some of the keys in format do not appear in 
def validate_data_format(original_data, format)
  valid = true
  data = original_data.dup
  for key, value in format
    valid &&= data.has_key?(key)
    datum = data.delete(key)
    case value
    when Array
      valid &&= datum.is_a?(Array)
      for element in datum
        type = value.first
        if type.is_a?(Hash)
          valid &&= validate_data_format({:element => element}, {:element => type})
        else
          valid &&= element.is_a?(type)
        end
      end
    when Hash
      valid &&= datum.is_a?(Hash)
      valid &&= validate_data_format(datum, value)
    else
      valid &&= datum.is_a?(value)
    end
  end
  unless data.empty?
    p "validate_data_format did not validate [#{data.inspect}]"
  end
  valid &&= data.empty?
end

def wait_for(timeout = 600, &block)
  start = Time.now
  until instance_eval(&block)
    if Time.now - start > timeout
      break
    end
    sleep(1)
  end
end