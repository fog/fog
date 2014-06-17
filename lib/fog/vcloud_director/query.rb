require 'pp'
module Fog
  module VcloudDirector
    module Query

      def find_by_query(options={})
        type = options.fetch(:type) { self.query_type }

        results = get_all_results(type, options)
        data = results.map do |query_record|
          model_data = {}
          model_data[:id] = query_record[:href].split('/').last
          model_data[:name] = query_record.fetch(:name) if query_record.key?(:name)
          if self.methods.include?(:populate_model_from_query_record)
            model_data.merge(self.populate_model_from_query_record(query_record))
          else
            model_data
          end
        end
        load(data)
      end

      private

      def get_all_results(type, options)
        results = []
        if options.key?(:page)
          page_range = [ Integer(options[:page]) ]
        else
          page_range = (1..get_num_pages(type, options))
        end
        page_range.each do |page|
          results += get_results_page(page, type, options) || []
        end
        results
      end

      def get_num_pages(type, options)
        body = service.get_execute_query(type, options)
        last_page = body[:lastPage] || 1
        raise "Invalid lastPage (#{last_page}) in query results" unless last_page.is_a? Integer
        last_page.to_i
      end

      def get_results_page(page, type, options)
        body = service.get_execute_query(type, options.merge({:page=>page})).body

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
