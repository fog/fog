module Fog
  module VcloudDirector
    module Query

      def find_by_query(type, options)
        results = get_all_results(type, options)
        results.map do |result|
          { :id => result[:href].split('/').last }
        end
      end

      private

      def get_entity_types_in_record_format(query_body)
        query_links = query_body.fetch(:Link).select do |link|
          link[:rel] == 'down'
        end
        entity_types = []
        query_links.each do |link|
          (entity_type, query_format) = extract_query_type_and_format_from_link(link)
          entity_types << entity_type if query_format == 'records'
        end
        entity_types
      end

      def extract_query_type_and_format_from_link(link)
          href  = Nokogiri::XML.fragment(link[:href])
          query = CGI.parse(URI.parse(href.text).query)
          query_format = query['format'].first
          query_type = query['type'].first
          [query_type, query_format]
      end

      def get_all_results(type, options)
        results = []
        (1..get_num_pages(type, options)).each do |page|
          results += get_results_page(page, type, options) || []
        end
        results
      end

      def get_num_pages(type, options)
        body = @fsi.get_execute_query(type, options)
        last_page = body[:lastPage] || 1
        raise "Invalid lastPage (#{last_page}) in query results" unless last_page.is_a? Integer
        last_page.to_i
      end

      def get_results_page(page, type, options)
        body = @fsi.get_execute_query(type, options.merge({:page=>page}))

        record_key = key_of_first_record_or_reference(body)
        body[record_key] = [body[record_key]] if body[record_key].is_a?(Hash)
        body[record_key]
      end

      def key_of_first_record_or_reference(body)
        body.keys.detect { |key| key.to_s =~ /Record|Reference$/ }
      end

    end
  end
end
