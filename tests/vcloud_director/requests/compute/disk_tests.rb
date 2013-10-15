Shindo.tests('Compute::VcloudDirector | disk requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('#get_disks_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_disks_from_query(:format => format).body
        end
        key = (format == 'references') ? 'DiskReference' : 'DiskRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

  tests('Retrieve non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
    pending if Fog.mocking?
    @service.get_disk('00000000-0000-0000-0000-000000000000')
  end

end
