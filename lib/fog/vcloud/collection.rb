module Fog
  module Vcloud
    class Collection < Fog::Collection

      class << self

        def inherited(klass)
          klass.instance_variable_set(:@model, @model)
          klass.all_request @all_request
          klass.vcloud_type @vcloud_type
          klass.get_request @get_request
        end

        def all_request(all_request=nil)
          unless all_request
            @all_request
          else
            @all_request = all_request
            class_eval <<-EOS, __FILE__, __LINE__
              def all
                data = self.class.all_request.call(self).body.links.select do |link|
                  link.type == self.class.vcloud_type
                end.map { |link| {:href => link.href, :name => link.name } }
                load(data)
              end
            EOS
          end
        end

        def vcloud_type(vcloud_type=nil)
          unless vcloud_type
            @vcloud_type
          else
            @vcloud_type = vcloud_type
          end
        end

        def get_request(get_request=nil)
          unless get_request
            @get_request
          else
            @get_request = get_request
            class_eval <<-EOS, __FILE__, __LINE__
              def get(uri)
                item = new(:href => uri)
                item.reload
              end
              def get_raw(uri)
                connection.#{@get_request}(uri)
              end
            EOS
          end
        end
      end

      attr_accessor :href

      def create(attributes = {})
        attributes.merge!(:new => true)
        obj = super(attributes)
        self << obj
        obj
      end

      def each
        super do |item|
          item.reload
          yield(item)
        end
      end

      def [](index)
        if obj = super
          obj.reload unless obj.loaded?
        end
        obj
      end

      #def reload
      #  self.all
      #end

    end
  end
end
