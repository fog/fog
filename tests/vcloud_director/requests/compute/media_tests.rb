Shindo.tests('Compute::VcloudDirector | media requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)
  @media_name = VcloudDirector::Compute::Helper.test_name

  tests('Upload and manipulate a media object') do
    File.open(VcloudDirector::Compute::Helper.fixture('test.iso'), 'rb') do |iso|
      tests('#post_upload_media').data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        pending if Fog.mocking?
        @vdc_id = VcloudDirector::Compute::Helper.first_vdc_id(@org)
        @media = @service.post_upload_media(@vdc_id, @media_name, 'iso', iso.size).body
      end

      file = @media[:Files][:File]
      file[:Link] = [file[:Link]] if file[:Link].is_a?(Hash)
      link = file[:Link].detect {|l| l[:rel] == 'upload:default'}

      headers = {
        'Content-Length' => iso.size,
        'Content-Type' => 'application/octet-stream',
        'x-vcloud-authorization' => @service.vcloud_token
      }
      Excon.put(
        link[:href], :body => iso.read, :expects => 200, :headers => headers
      )

      @service.process_task(@media[:Tasks][:Task])
      @media_id = @media[:href].split('/').last

      tests("#get_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        pending if Fog.mocking?
        @media = @service.get_media(@media_id).body
      end
      tests("media[:name]").returns(@media_name) { @media[:name] }
      tests("media[:imageType]").returns('iso') { @media[:imageType] }
      tests("media[:size]").returns(iso.size) { @media[:size].to_i }

      tests("#get_media_owner(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::OWNER_TYPE) do
        pending if Fog.mocking?
        @owner = @service.get_media_owner(@media_id).body
      end
      tests("owner[:User][:name]").returns(@service.user_name) { @owner[:User][:name] }

      tests("#get_media_metadata(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
        pending if Fog.mocking?
        @service.get_media_metadata(@media_id).body
      end

      tests("#post_clone_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        pending if Fog.mocking?
        @media = @service.post_clone_media(@vdc_id, @media_id, :IsSourceDelete => true).body
      end
      @service.process_task(@media[:Tasks][:Task])
      @media_id = @media[:href].split('/').last
      tests("media[:name] starts '#{@media_name}-copy-'").returns(true) do
        !!(@media[:name] =~ /^#{@media_name}-copy-/)
      end

      tests("#delete_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
        pending if Fog.mocking?
        @task = @service.delete_media(@media_id).body
      end
      @service.process_task(@task)
    end
  end

  tests('Media item no longer exists') do
    tests("#get_media(#{@media_id})").raises(Excon::Errors::Forbidden) do
      @service.get_media(@media_id)
    end
    tests("#get_media_owner(#{@media_id})").raises(Excon::Errors::Forbidden) do
      @service.get_media_owner(@media_id)
    end
    tests("#get_media_metadata(#{@media_id})").raises(Excon::Errors::Forbidden) do
      @service.get_media_metadata(@media_id)
    end
    tests("#delete_media(#{@media_id})").raises(Excon::Errors::Forbidden) do
      @service.delete_media(@media_id)
    end
  end

  tests('#get_medias_from_query').returns(Hash) do
    pending if Fog.mocking?
    @service.get_medias_from_query.body.class
  end

  tests('Upload to non-existent vDC').raises(Excon::Errors::Forbidden) do
    @service.get_media('00000000-0000-0000-0000-000000000000')
  end

end
