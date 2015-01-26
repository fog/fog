module Fog
  module CloudSigma
    class CloudsigmaModel < Fog::Model
      class << self
        def model_attribute_array(name, model, options={})
          attributes_key = options[:aliases] || name
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              #{name}_attrs = attributes[:#{attributes_key}] || []
              refreshed_#{name} = #{name}_attrs.map { |x| #{model}.new(x) }
              attributes[:#{attributes_key}] = refreshed_#{name}.map { |x| x.attributes }

              refreshed_#{name}
            end
            def #{name}=(new_#{name})
              new_#{name} ||= []
              attributes[:#{attributes_key}] = new_#{name}.map { |x| x.kind_of?(Hash) ? x : x.attributes}
            end
          EOS

          @attributes ||= []
          @attributes |= [name]
          for new_alias in [*options[:aliases]]
            aliases[new_alias] = name
          end
        end

        def model_attribute(name, model, options={})
          attributes_key = options[:aliases] || name
          class_eval <<-EOS, __FILE__, __LINE__
            def #{name}
              #{name}_attrs = attributes[:#{attributes_key}]
              if #{name}_attrs
                refreshed_#{name} = #{name}_attrs ?  #{model}.new(#{name}_attrs) : nil
                attributes[:#{attributes_key}] = refreshed_#{name}.attributes

                refreshed_#{name}
              else
                nil
              end
            end
            def #{name}=(new_#{name})
              if new_#{name}
                attributes[:#{attributes_key}] = new_#{name}.kind_of?(Hash) ? new_#{name} : new_#{name}.attributes
              else
                nil
              end
            end
          EOS

          @attributes ||= []
          @attributes |= [name]
          for new_alias in [*options[:aliases]]
            aliases[new_alias] = name
          end
        end
      end
    end
  end
end
