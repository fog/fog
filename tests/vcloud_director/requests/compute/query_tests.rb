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

  # for each queriable type, query and check that each available format
  # returns a result that matches the base schema
  #
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

      pending if Fog.mocking? && (format != 'records' || type != 'orgVdcNetwork')

      tests("#get_execute_query").data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
        @body = @service.get_execute_query(type, :format => format).body
      end
      tests("resource type").returns(link[:type]) { @body[:type] }

      unless ( type == 'event' || type == 'edgeGateway' )
        records_key = @body.keys.find {|key| key.to_s =~ /Record|Reference$/}
        if records = @body[records_key]
          records.first do |record|
            case format
            when 'records'
              tests("record is correct schema").data_matches_schema(VcloudDirector::Compute::Schema::REFERENCE_TYPE) do
                record
              end
            end
          end
        end
      end

    end
  end

  if Fog.mocking?
    tests('ensure Mock logic is sound') do
      tests('#get_execute_query') do
        tests('orgVdcNetwork') do
          output = @service.get_execute_query('orgVdcNetwork').body
          tests('all records').returns(@service.data[:networks].size) do
            output[:OrgVdcNetworkRecords].size
          end
          output = @service.get_execute_query('orgVdcNetwork', :filter => 'name==vDC1 backend network').body
          tests(':filter by name').returns(1) do
            output[:OrgVdcNetworkRecords].size
          end
          tests(':page option is ok if :page == 1').returns(@service.data[:networks].size) do
            output = @service.get_execute_query('orgVdcNetwork', :page => '1').body
            output[:OrgVdcNetworkRecords].size
          end
          tests('AND expression in :filter raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :filter => 'name==Default Network;thing==wibble')
          end
          tests('OR expression in :filter raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :filter => 'name==Default Network,thing==wibble')
          end
          tests('sortAsc option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :sortAsc => 'name')
          end
          tests('sortDesc option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :sortDesc => 'name')
          end
          tests('page option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :page => '2')
          end
          tests('pageSize option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :pageSize => '50')
          end
          tests('offset option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :offset => '5')
          end
          tests('fields option raises MockNotImplemented').raises(Fog::Errors::MockNotImplemented) do
            @service.get_execute_query('orgVdcNetwork', :fields => 'name,thing')
          end
        end
      end
    end
  end

end
