Shindo.tests('Compute::VcloudDirector | organization requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_organizations').data_matches_schema(VcloudDirector::Compute::Schema::ORG_LIST_TYPE) do
    @org_list = @service.get_organizations.body
  end

  tests('#get_organization').data_matches_schema(VcloudDirector::Compute::Schema::ORG_TYPE) do
    org = @org_list[:Org].find {|o| o[:name] == @service.org_name}
    @org_uuid = org[:href].split('/').last
    @service.get_organization(@org_uuid).body
  end

  tests('#get_organization_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_organization_metadata(@org_uuid).body
  end

  tests('#get_organizations_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_organizations_from_query(:format => format).body
        end
        key = (format == 'references') ? 'OrganizationReference' : 'OrganizationRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

  tests('retrieve non-existent Org').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_organization('00000000-0000-0000-0000-000000000000')
  end

end
