Shindo.tests('Compute::VcloudDirector | users requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_users_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_users_from_query(:format => format).body
        end
        key = (format == 'references') ? 'UserReference' : 'UserRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

end
