module Fog
  module Attributes
    module ClassMethods

      def _load(marshalled)
        new(Marshal.load(marshalled))
      end

      def aliases
        @aliases ||= {}
      end

      def attributes
        @attributes ||= []
      end

      def attribute(name, options = {})
        class_eval <<-EOS, __FILE__, __LINE__
          def #{name}
            attributes[:#{name}]
          end
        EOS
        case options[:type]
        when :boolean
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = case new_#{name}
              when true,'true'
                true
              when false,'false'
                false
              end
            end
          EOS
        when :float
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = new_#{name}.to_f
            end
          EOS
        when :integer
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = new_#{name}.to_i
            end
          EOS
        when :string
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = new_#{name}.to_s
            end
          EOS
        when :time
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = if new_#{name}.nil? || new_#{name} == "" || new_#{name}.is_a?(Time)
                new_#{name}
              else
                Time.parse(new_#{name})
              end
            end
          EOS
        when :timestamp
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}=(new_#{name})
              attributes[:#{name}] = Time.at(new_#{name}.to_i)
            end
          EOS
        when :array
          class_eval <<-EOS, __FILE__, __LINE__
          def #{name}=(new_#{name})
            attributes[:#{name}] = [*new_#{name}]
          end
          EOS
        else
          if squash = options[:squash]
            class_eval <<-EOS, __FILE__, __LINE__
              def #{name}=(new_data)
                if new_data.is_a?(Hash)
                  if new_data.has_key?(:'#{squash}')
                    attributes[:#{name}] = new_data[:'#{squash}']
                  elsif new_data.has_key?("#{squash}")
                    attributes[:#{name}] = new_data["#{squash}"]
                  else
                    attributes[:#{name}] = [ new_data ]
                  end
                else
                  attributes[:#{name}] = new_data
                end
              end
            EOS
          else
            class_eval <<-EOS, __FILE__, __LINE__
              def #{name}=(new_#{name})
                attributes[:#{name}] = new_#{name}
              end
            EOS
          end
        end
        @attributes ||= []
        @attributes |= [name]
        for new_alias in [*options[:aliases]]
          aliases[new_alias] = name
        end
      end

      def identity(name, options = {})
        @identity = name
        self.attribute(name, options)
      end

      def ignore_attributes(*args)
        @ignored_attributes = args.collect {|attr| attr.to_s }
      end

      def ignored_attributes
        @ignored_attributes ||= []
      end

    end

    module InstanceMethods

      def _dump(level)
        Marshal.dump(attributes)
      end

      def attributes
        @attributes ||= {}
      end

      def dup
        copy = super
        copy.dup_attributes!
        copy
      end

      def identity
        send(self.class.instance_variable_get('@identity'))
      end

      def identity=(new_identity)
        send("#{self.class.instance_variable_get('@identity')}=", new_identity)
      end

      def merge_attributes(new_attributes = {})
        for key, value in new_attributes
          unless self.class.ignored_attributes.include?(key)
            if aliased_key = self.class.aliases[key]
              send("#{aliased_key}=", value)
            elsif self.respond_to?("#{key}=",true)
              send("#{key}=", value)
            else
              attributes[key] = value
            end
          end
        end
        self
      end

      # Returns true if a remote resource has been assigned an
      # identity and we can assume it has been persisted.
      #
      # @return [Boolean]
      def persisted?
        !!identity
      end

      # Returns true if a remote resource has not been assigned an
      # identity.
      #
      # This was added for a ActiveRecord like feel but has been
      # outdated by ActiveModel API using {#persisted?}
      #
      # @deprecated Use inverted form of {#persisted?}
      # @return [Boolean]
      def new_record?
        Fog::Logger.deprecation("#new_record? is deprecated, use !persisted? instead [light_black](#{caller.first})[/]")
        !persisted?
      end

      # check that the attributes specified in args exist and is not nil
      def requires(*args)
        missing = missing_attributes(args)
        if missing.length == 1
          raise(ArgumentError, "#{missing.first} is required for this operation")
        elsif missing.any?
          raise(ArgumentError, "#{missing[0...-1].join(", ")} and #{missing[-1]} are required for this operation")
        end
      end

      def requires_one(*args)
        missing = missing_attributes(args)
        if missing.length == args.length
          raise(ArgumentError, "#{missing[0...-1].join(", ")} or #{missing[-1]} are required for this operation")
        end
      end

      protected

      def missing_attributes(args)
        missing = []
        for arg in [:service] | args
          unless send("#{arg}") || attributes.has_key?(arg)
            missing << arg
          end
        end
        missing
      end

      def dup_attributes!
        @attributes = @attributes.dup if @attributes
      end

      private

      def remap_attributes(attributes, mapping)
        for key, value in mapping
          if attributes.key?(key)
            attributes[value] = attributes.delete(key)
          end
        end
      end

    end
  end
end
