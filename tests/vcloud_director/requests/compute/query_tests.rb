Shindo.tests('Compute::VcloudDirector | query requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('retrieve a summary list of all typed queries types') do
    tests('#get_execute_query') do
      @query_list = @service.get_execute_query.body
      tests(':type').returns('application/vnd.vmware.vcloud.query.queryList+xml') do
        @query_list[:type]
      end
    end
  end

  pending if Fog.mocking?

  @query_list[:Link].select do |link|
    link[:rel] == 'down'
  end.sort_by do |link|
    [link[:name], link[:href]]
  end.each do |link|
    href = Nokogiri::XML.fragment(link[:href])
    query = CGI.parse(URI.parse(href.text).query)
    type = query['type'].first
    format = query['format'].first
    next if %w[right role strandedUser].include?(type)
    tests("type => #{type}, format => #{format}") do
      tests("#get_execute_query").data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
        @body = @service.get_execute_query(type, :format => format).body
      end
      tests("resource type").returns(link[:type]) { @body[:type] }
    end
  end

end
