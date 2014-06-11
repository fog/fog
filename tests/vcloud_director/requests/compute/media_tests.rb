Shindo.tests('Compute::VcloudDirector | media requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('error conditions') do
    tests('#post_upload_media') do
      tests('Invalid image_type').raises(Fog::Compute::VcloudDirector::BadRequest) do
        @service.post_upload_media('00000000-0000-0000-0000-000000000000', 'test.iso', 'isox', 0)
      end
      tests('Invalid size').raises(Fog::Compute::VcloudDirector::BadRequest) do
        @service.post_upload_media('00000000-0000-0000-0000-000000000000', 'test.iso', 'iso', -1)
      end
    end
    tests('Upload to non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.post_upload_media('00000000-0000-0000-0000-000000000000', 'test.iso', 'iso', 0)
    end
    tests('Retrieve non-existent Media').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_media('00000000-0000-0000-0000-000000000000')
    end
    tests('Retrieve owner of non-existent Media').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_media_owner('00000000-0000-0000-0000-000000000000')
    end
    tests('Delete non-existent Media').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.delete_media('00000000-0000-0000-0000-000000000000')
    end
  end

  @org = VcloudDirector::Compute::Helper.current_org(@service)
  @media_name = VcloudDirector::Compute::Helper.test_name

  tests('Upload and manipulate a media object') do
    File.open(VcloudDirector::Compute::Helper.fixture('test.iso'), 'rb') do |iso|
      tests('#post_upload_media').data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        @vdc_id = VcloudDirector::Compute::Helper.first_vdc_id(@org)
        @size = File.size(iso.path)
        @media = @service.post_upload_media(@vdc_id, @media_name, 'iso', @size).body
      end

      tests('media object has exactly one file').returns(true) do
        @media[:Files][:File].size == 1
      end

      tests('media object file has an upload link').returns(true) do
        @link = @media[:Files][:File].first[:Link]
        @link[:rel] == 'upload:default'
      end

      unless Fog.mocking?
        headers = {
          'Content-Length' => @size,
          'Content-Type' => 'application/octet-stream',
          'x-vcloud-authorization' => @service.vcloud_token
        }
        Excon.put(
          @link[:href], :body => iso.read, :expects => 200, :headers => headers
        )
      end

      @service.process_task(@media[:Tasks][:Task])
      @media_id = @media[:href].split('/').last

      tests("#get_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        @media = @service.get_media(@media_id).body
      end
      tests("media[:name]").returns(@media_name) { @media[:name] }
      tests("media[:imageType]").returns('iso') { @media[:imageType] }
      tests("media[:size]").returns(@size) { @media[:size].to_i }

      tests("#get_media_owner(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::OWNER_TYPE) do
        @owner = @service.get_media_owner(@media_id).body
      end
      tests("owner[:User][:name]").returns(@service.user_name) { @owner[:User][:name] }

      tests('media metadata') do
        pending if Fog.mocking?

        tests("#put_media_metadata_item_metadata(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
          @task = @service.put_media_metadata_item_metadata(@media_id, 'fog-test-key', 'fog-test-value').body
        end
        @service.process_task(@task)

        tests("#put_media_metadata_item_metadata(#{@media_id})") do
          tests("#put_media_metadata_item_metadata(Boolean)").returns(true) do
            task = @service.put_media_metadata_item_metadata(@media_id, 'fog-test-boolean', true).body
            @service.process_task(task)
          end
          tests("#put_media_metadata_item_metadata(DateTime)").returns(true) do
            task = @service.put_media_metadata_item_metadata(@media_id, 'fog-test-datetime', DateTime.now).body
            @service.process_task(task)
          end
          tests("#put_media_metadata_item_metadata(Number)").returns(true) do
            task = @service.put_media_metadata_item_metadata(@media_id, 'fog-test-number', 111).body
            @service.process_task(task)
          end
        end

        tests("#post_update_media_metadata(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
          metadata = {
            'fog-test-key-update' => 'fog-test-value-update',
            'fog-test-boolean-update' => false,
            'fog-test-datetime-update' => DateTime.now,
            'fog-test-number-update' => 222
          }
          @task = @service.post_update_media_metadata(@media_id, metadata).body
        end
        @service.process_task(@task)

        tests("#get_media_metadata(#{@media_id})") do
          tests('response format').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
            @metadata = @service.get_media_metadata(@media_id).body
          end
          tests('TypedValue') do
            pending if @service.api_version.to_f < 5.1
            tests('key').returns('MetadataStringValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-key'}
              entry[:TypedValue][:xsi_type]
            end
            tests('boolean').returns('MetadataBooleanValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-boolean'}
              entry[:TypedValue][:xsi_type]
            end
            tests('datetime').returns('MetadataDateTimeValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-datetime'}
              entry[:TypedValue][:xsi_type]
            end
            tests('number').returns('MetadataNumberValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-number'}
              entry[:TypedValue][:xsi_type]
            end
            tests('key-update').returns('MetadataStringValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-key-update'}
              entry[:TypedValue][:xsi_type]
            end
            tests('boolean-update').returns('MetadataBooleanValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-boolean-update'}
              entry[:TypedValue][:xsi_type]
            end
            tests('datetime-update').returns('MetadataDateTimeValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-datetime-update'}
              entry[:TypedValue][:xsi_type]
            end
            tests('number-update').returns('MetadataNumberValue') do
              entry = @metadata[:MetadataEntry].find {|e| e[:Key] == 'fog-test-number-update'}
              entry[:TypedValue][:xsi_type]
            end
          end
        end
      end

      tests("#post_clone_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::MEDIA_TYPE) do
        @media = @service.post_clone_media(@vdc_id, @media_id, :IsSourceDelete => true).body
      end
      @service.process_task(@media[:Tasks][:Task])
      @media_id = @media[:href].split('/').last
      tests("media[:name] starts '#{@media_name}-copy-'").returns(true) do
        !!(@media[:name] =~ /^#{@media_name}-copy-/)
      end

      tests("#delete_media(#{@media_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
        @task = @service.delete_media(@media_id).body
      end
      @service.process_task(@task)
    end
  end

  tests('Media item no longer exists') do
    tests("#get_media(#{@media_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_media(@media_id)
    end
    tests("#get_media_owner(#{@media_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_media_owner(@media_id)
    end
    tests("#get_media_metadata(#{@media_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      pending if Fog.mocking?
      @service.get_media_metadata(@media_id)
    end
    tests("#delete_media(#{@media_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.delete_media(@media_id)
    end
  end

  tests('#get_medias_from_query') do
    pending if Fog.mocking?
    %w[idrecords records references].each do |format|
      tests(":format => #{format}") do
        tests('#body').data_matches_schema(VcloudDirector::Compute::Schema::CONTAINER_TYPE) do
          @body = @service.get_medias_from_query(:format => format).body
        end
        key = (format == 'references') ? 'MediaReference' : 'MediaRecord'
        tests("#body.key?(:#{key})").returns(true) { @body.key?(key.to_sym) }
      end
    end
  end

end
