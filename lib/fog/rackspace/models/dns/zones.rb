require 'fog/core/collection'
require 'fog/rackspace/models/dns/zone'

module Fog
  module DNS
    class Rackspace
      class Zones < Fog::Collection
        attribute :total_entries, :aliases => "totalEntries"

        model Fog::DNS::Rackspace::Zone

        # List all domains. Return by default a maximum of 100 items
        # @param [Hash] options Options to pass to the underlying API call
        # @option options [String] :name search for domains containing the given substring
        # @option options [Integer] :limit number of records to return
        # @option options [Integer] :offset starting offset of records to return
        def all(options={})
          clear
          body = service.list_domains(options).body
          merge_attributes(body)

          load(body['domains'])
        end

        alias_method :each_zone_this_page, :each
        def each
          return self unless block_given?

          params = { :limit => 100} # prime loop (100 Records is default page size for Rackspace Cloud)
          while params
            body = service.list_domains(params).body
            subset = dup.load(body["domains"])
            self.merge_attributes(body)

            params = next_params(body)

            subset.each_zone_this_page {|zone| yield zone}
          end
          self
        end

        def get(zone_id)
          if zone_id.nil? or zone_id.to_s.empty?
            return nil
          end

          data = service.list_domain_details(zone_id).body
          new(data)
        rescue Fog::DNS::Rackspace::NotFound
          # if we can't find it by id, go back and find it via domain
          find{|z| z.domain == zone_id}
        #Accessing a valid (but other customer's) id returns a 503 error
        rescue Fog::Rackspace::Errors::ServiceUnavailable
          nil
        end

        private
        def next_params(body)
          # return if we don't have any links
          return nil unless body && body['links']

          #return if links don't contain a href for the next page
          next_link = body['links'].find {|h| h['rel'] == 'next'}
          return nil unless next_link && next_link['href']

          url = next_link['href']
          uri = URI.parse url
          return nil unless uri.query
          CGI.parse uri.query
        end
      end
    end
  end
end
