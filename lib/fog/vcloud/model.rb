module Fog
  module Vcloud
    class Model < Fog::Model

      #def self.attribute(name, other_names = [])
      #  super
      #  class_eval <<-EOS, __FILE__, __LINE__
      #    def #{name}=(new_#{name})
      #      @#{name} = new_#{name}
      #    end
      #  EOS
      #end

      def self.inherited(klass)
          attributes.each { |attribute| klass.attribute attribute }
          klass.instance_variable_set(:@identity, @identity)
          klass.instance_variable_set(:@aliases, @aliases)
        end

      def self.delete_attribute(name)
        if @attributes.reject! { |item| item == name }
          class_eval <<-EOS,__FILE__,__LINE__
            undef_method :#{name}
            undef_method :#{name}=
          EOS
          aliases.reject! { |key, value| value == name || key == name }
        end
      end

      attr_accessor :loaded
      alias_method :loaded?, :loaded

      def reload
        if data = collection.get_raw(identity)
          merge_get_raw_result(data)
          @loaded = true
          self
        end
      end

      def merge_get_raw_result(data)
        #data.body.each_pair do |key,value|
        (data.respond_to?(:body) ? data.body : data).each_pair do |key,value|
          if aliased_key = self.class.aliases[key]
            send("#{aliased_key}=", value)
          else
            send("#{key}=", value)
          end
        end
      end

    end
  end
end
