module Fog
  class Collection < Array

    def self.attribute(name, other_names = [])
      class_eval <<-EOS, __FILE__, __LINE__
        attr_accessor :#{name}
      EOS
      attributes << name
      for other_name in [*other_names]
        aliases[other_name] = name
      end
    end

    def self.model(new_model)
      @model = new_model
    end
    
    def self.aliases
      @aliases ||= {}
    end

    def self.attributes
      @attributes ||= []
    end

    def attributes
      attributes = {}
      for attribute in self.class.attributes
        attributes[attribute] = send("#{attribute}")
      end
      attributes
    end

    def create(attributes = {})
      object = new(attributes)
      object.save
      object
    end

    def initialize(attributes = {})
      merge_attributes(attributes)
    end

    def inspect
      data = "#<#{self.class.name}"
      for attribute in self.class.attributes
        data << " #{attribute}=#{send(attribute).inspect}"
      end
      data << " ["
      for member in self
        data << "#{member.inspect},"
      end
      data.chop! unless self.empty?
      data << "]>"
    end

    def model
      self.class.instance_variable_get('@model')
    end

    def merge_attributes(new_attributes = {})
      for key, value in new_attributes
        if aliased_key = self.class.aliases[key]
          send("#{aliased_key}=", value)
        else
          send("#{key}=", value)
        end
      end
      self
    end

    def new(attributes = {})
      model.new(
        attributes.merge!(
          :collection => self,
          :connection => connection
        )
      )
    end

    def reload
      self.clear.concat(all)
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
