module Fog
  class Model

    def initialize(new_attributes = {})
      merge_attributes(new_attributes)
    end

    def inspect
      data = "#<#{self.class.name}"
      for attribute in (self.instance_variables - ['@connection'])
        data << " #{attribute}=#{send(attribute[1..-1].to_sym).inspect}"
      end
      data << ">"
    end

    def merge_attributes(new_attributes = {})
      for key, value in new_attributes
        send(:"#{key}=", value)
      end
      self
    end

    private

    def connection=(new_connection)
      @connection = new_connection
    end

    def connection
      @connection
    end

    def remap_attributes(attributes, mapping)
      for key, value in mapping
        if attributes.key?(key)
          attributes[value] = attributes.delete(key)
        end
      end
    end

  end
end
