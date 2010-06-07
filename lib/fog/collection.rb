module Fog
  class Collection < Array

    extend Attributes::ClassMethods
    include Attributes::InstanceMethods

    Array.public_instance_methods(false).each do |method|
      class_eval <<-RUBY
        def #{method}(*args)
          lazy_load
          super
        end
      RUBY
    end

    %w[reject select].each do |method|
      class_eval <<-RUBY
        def #{method}(*args)
          lazy_load
          data = super
          self.class.new(:connection => self.connection).load(data.map {|member| member.attributes})
        end
      RUBY
    end

    def self.model(new_model=nil)
      if new_model == nil
        @model
      else
        @model = new_model
      end
    end

    attr_accessor :connection

    def create(attributes = {})
      object = new(attributes)
      object.save
      object
    end

    def initialize(attributes = {})
      merge_attributes(attributes)
      @loaded = false
    end

    def inspect
      Thread.current[:formatador] ||= Formatador.new
      data = "#{Thread.current[:formatador].indentation}<#{self.class.name}\n"
      Thread.current[:formatador].indent do
        unless self.class.attributes.empty?
          data << "#{Thread.current[:formatador].indentation}"
          data << self.class.attributes.map {|attribute| "#{attribute}=#{send(attribute).inspect}"}.join(",\n#{Thread.current[:formatador].indentation}")
          data << "\n"
        end
        data << "#{Thread.current[:formatador].indentation}["
        unless self.empty?
          data << "\n"
          Thread.current[:formatador].indent do
            data << self.map {|member| member.inspect}.join(",\n")
            data << "\n"
          end
          data << Thread.current[:formatador].indentation
        end
        data << "]\n"
      end
      data << "#{Thread.current[:formatador].indentation}>"
      data
    end

    def load(objects)
      if @loaded
        clear
      end
      @loaded = true
      for object in objects
        self << new(object)
      end
      self
    end

    def model
      self.class.instance_variable_get('@model')
    end

    def new(attributes = {})
      model.new(
        attributes.merge(
          :collection => self,
          :connection => connection
        )
      )
    end

    def reload
      self.clear.concat(all)
    end

    def table(attributes = nil)
      Formatador.display_table(self.map {|instance| instance.attributes}, attributes)
    end

    def to_json
      self.map {|member| member}.to_json
    end

    private

    def lazy_load
      unless @loaded
        self.all
      end
    end

  end
end
