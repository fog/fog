require 'fog/core/model'

module Fog
  module DNS
    class DNSMadeEasy

      class Record < Fog::Model
        extend Fog::Deprecation
        deprecate :ip, :value
        deprecate :ip=, :value=
        
        identity :id

        attribute :name
        attribute :type
        attribute :ttl
        attribute :gtd_location,  :aliases => "gtdLocation"
        attribute :password
        attribute :description
        attribute :keywords
        attribute :title
        attribute :redirect_type, :aliases => "redirectType"
        attribute :hard_link, :aliases => "hardLink"

        attribute :value,          :aliases => "data"
  
        def initialize(attributes={})
          self.ttl ||= 1800
          super
        end

        def destroy
          connection.delete_record(zone.domain, identity)
          true
        end

        def zone
          @zone
        end

        def save
          requires :name, :type, :value, :ttl
          options = {}
          options[:ttl]  = ttl if ttl
          options[:gtdLocation]  = gtd_location if gtd_location

          if type.upcase == 'A'
            options[:password]  = password if password
          end

          if type.upcase == 'HTTPRED'
            options[:description]  = description if description
            options[:keywords]  = keywords if keywords
            options[:title]  = title if title
            options[:redirectType]  = redirect_type if redirect_type
            options[:hardLink]  = hard_link if hard_link
          end

          if id.nil?
            data = connection.create_record(zone.domain, name, type, value, options).body
            merge_attributes(data)
          else
            options.merge!(:name => name, :type => type, :data => value)
            connection.update_record(zone.domain, id, options).body
          end

          true
        end

        private

        def zone=(new_zone)
          @zone = new_zone
        end

      end

    end
  end
end
