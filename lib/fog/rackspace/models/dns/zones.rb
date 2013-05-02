require 'fog/core/collection'
require 'fog/rackspace/models/dns/zone'

module Fog
  module DNS
    class Rackspace
      class Zones < Fog::Collection

        model Fog::DNS::Rackspace::Zone

        # List all domains. Return by default a maximum of 100 items
        # @param [Hash] options Options to pass to the underlying API call 
        # @option options [String] :name search for domains containing the given substring
        # @option options [Integer] :limit number of records to return
        # @option options [Integer] :offset starting offset of records to return
        def all(options={})
          clear
          data = service.list_domains(options).body['domains']
          load(data)
        end
        
        alias :each_zone_this_page :each
        def each
          if !block_given?
            self
          else
            body = service.list_domains.body
            subset = dup.all

            subset.each_zone_this_page {|f| yield f}
            if body.has_key?('links')
              while !body['links'].select{|l| l['rel'] == 'next'}.empty?
                url = body['links'].select{|l| l['rel'] == 'next'}.first['href']
                query = url.match(/\?(.+)/)
                parsed = CGI.parse($1)
                
                body = service.list_domains(:offset => parsed['offset'], :limit => parsed['limit']).body
                subset = dup.all(:offset => parsed['offset'], :limit => parsed['limit'])
                subset.each_zone_this_page {|f| yield f}
              end
            end
            self
          end
        end

        def get(zone_id)
          if zone_id.nil? or zone_id.to_s.empty?
            return nil
          end

          data = service.list_domain_details(zone_id).body
          new(data)
        rescue Fog::DNS::Rackspace::NotFound
          nil
        #Accessing a valid (but other customer's) id returns a 503 error
        rescue Fog::Rackspace::Errors::ServiceUnavailable
          nil
        end
      end
    end
  end
end
