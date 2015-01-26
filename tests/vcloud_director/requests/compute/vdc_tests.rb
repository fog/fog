Shindo.tests('Compute::VcloudDirector | vdc requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('#get_vdc').data_matches_schema(VcloudDirector::Compute::Schema::VDC_TYPE) do
    link = @org[:Link].find do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    @vdc_id = link[:href].split('/').last
    @service.get_vdc(@vdc_id).body
  end

  tests('#get_vdc_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_vdc_metadata(@vdc_id).body
  end

  tests('#get_vdcs_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_vdcs_from_query(:format => format).body
        end
        key = (format == 'references') ? 'OrgVdcReference' : 'OrgVdcRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

  tests('Retrieve non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_vdc('00000000-0000-0000-0000-000000000000')
  end

end
