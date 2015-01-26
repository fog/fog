module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves a list of Catalogs by using REST API general QueryHandler.
        #
        # @param [Hash] options
        # @option options [String] :sortAsc (Sorted by database ID) Sort
        #   results by attribute-name in ascending order. attribute-name cannot
        #   include metadata.
        # @option options [String] :sortDesc (Sorted by database ID) Sort
        #   results by attribute-name in descending order. attribute-name
        #   cannot include metadata.
        # @option options [Integer] :page (1) If the query results span
        #   multiple pages, return this page.
        # @option options [Integer] :pageSize (25) Number of results per page,
        #   to a maximum of 128.
        # @option options [String] :format (records) One of the following
        #   types:
        #   - *references* Returns a reference to each object, including its
        #     :name, :type, and :href attributes.
        #   - *records* Returns all database records for each object, with each
        #     record as an attribute.
        #   - *idrecords* Identical to the records format, except that object
        #     references are returned in :id format rather than :href format.
        # @option options [Array<String>] :fields (all static attribute names)
        #   List of attribute names or metadata key names to return.
        # @option options [Integer] :offset (0) Integer value specifying the
        #   first record to return. Record numbers < offset are not returned.
        # @option options [String] :filter (none) Filter expression.
        # @return [Excon::Response]
        #   * hash<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :name<~String> - Query name that generated this result set.
        #     * :page<~String> - Page of the result set that this container
        #       holds. The first page is page number 1.
        #     * :pageSize<~String> - Page size, as a number of records or
        #       references.
        #     * :total<~String> - Total number of records or references in the
        #       container.
        #     * :Link<~Array<Hash>>:
        #       * :href<~String> - Contains the URI to the entity.
        #       * :type<~String> - Contains the type of the entity.
        #       * :rel<~String> - Defines the relationship of the link to the
        #         object that contains it.
        #     * :CatalogRecord<~Array<Hash>>:
        #       * TODO
        #     * :firstPage<~Integer> - First page in the result set.
        #     * :previousPage<~Integer> - Previous page in the result set.
        #     * :nextPage<~Integer> - Next page in the result set.
        #     * :lastPage<~Integer> - Last page in the result set.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CatalogsFromQuery.html
        # @since vCloud API version 1.5
        def get_catalogs_from_query(options={})
          query = []
          query << "sortAsc=#{options[:sortAsc]}" if options[:sortAsc]
          query << "sortDesc=#{options[:sortDesc]}" if options[:sortDesc]
          query << "page=#{options[:page]}" if options[:page]
          query << "pageSize=#{options[:pageSize]}" if options[:pageSize]
          query << "format=#{options[:format]}" if options[:format]
          query << "fields=#{Array(options[:fields]).join(',')}" if options[:fields]
          query << "offset=#{options[:offset]}" if options[:offset]
          query << "filter=#{options[:filter]}" if options[:filter]

          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'catalogs/query',
            :query      => query.map {|q| URI.escape(q)}.join('&')
          )
          ensure_list! response.body, :Link
          ensure_list! response.body,
            response.body[:type] == 'application/vnd.vmware.vcloud.query.references+xml' ?
              :CatalogReference : :CatalogRecord

          %w[firstPage previousPage nextPage lastPage].each do |rel|
            if link = response.body[:Link].find {|l| l[:rel] == rel}
              href = Nokogiri::XML.fragment(link[:href])
              query = CGI.parse(URI.parse(href.text).query)
              response.body[rel.to_sym] = query['page'].first.to_i
              response.body[:pageSize] ||= query['pageSize'].first.to_i
            end
          end

          response
        end
      end
    end
  end
end
