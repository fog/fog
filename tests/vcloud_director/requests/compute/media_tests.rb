Shindo.tests('Compute::VcloudDirector | media requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    link = session[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.org+xml'
    end
    @org = @service.get_organization(link[:href].split('/').last).body
  end

  tests('Each vDC') do
    @org[:Link].select do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end.each do |link|
      @vdc = @service.get_vdc(link[:href].split('/').last).body
      if @vdc[:ResourceEntities].is_a?(String)
        @vdc[:ResourceEntities] = {:ResourceEntity => []}
      elsif @vdc[:ResourceEntities][:ResourceEntity].is_a?(Hash)
        @vdc[:ResourceEntities][:ResourceEntity] = [@vdc[:ResourceEntities][:ResourceEntity]]
      end
      tests('Each Media') do
        @vdc[:ResourceEntities][:ResourceEntity].select do |r|
          r[:type] == 'application/vnd.vmware.vcloud.media+xml'
        end.each do |m|
          @media_id = m[:href].split('/').last
          tests("#get_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
            pending if Fog.mocking?
            @service.get_media(@media_id).body
          end
          tests("#get_media_owner(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::OWNER_TYPE) do
            pending if Fog.mocking?
            @service.get_media_owner(@media_id).body
          end
        end
      end
    end
  end

  tests('Upload to non-existent vDC').raises(Excon::Errors::Forbidden) do
    @service.get_media('00000000-0000-0000-0000-000000000000')
  end

  tests('Retrieve non-existent Media').raises(Excon::Errors::Forbidden) do
    @service.get_media('00000000-0000-0000-0000-000000000000')
  end

  tests('Retrieve owner of non-existent Media').raises(Excon::Errors::Forbidden) do
    @service.get_media_owner('00000000-0000-0000-0000-000000000000')
  end

  tests('Delete non-existent Media').raises(Excon::Errors::Forbidden) do
    @service.delete_media('00000000-0000-0000-0000-000000000000')
  end

end
