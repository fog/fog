Shindo.tests('Compute::VcloudDirector | disk requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @disk_name = VcloudDirector::Compute::Helper.test_name

  tests('error conditions') do
    tests('#post_upload_disk') do
      tests('Invalid size').raises(Fog::Compute::VcloudDirector::BadRequest) do
        @service.post_upload_disk('00000000-0000-0000-0000-000000000000', @disk_name, -1)
      end
    end
    tests('Upload to non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.post_upload_disk('00000000-0000-0000-0000-000000000000', @disk_name, 0)
    end
    tests('Retrieve non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_disk('00000000-0000-0000-0000-000000000000')
    end
    tests('Retrieve owner of non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_disk_owner('00000000-0000-0000-0000-000000000000')
    end
    tests('Retrieve VM list for non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_vms_disk_attached_to('00000000-0000-0000-0000-000000000000')
    end
    tests('Delete non-existent Disk').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.delete_disk('00000000-0000-0000-0000-000000000000')
    end
  end

  @org = VcloudDirector::Compute::Helper.current_org(@service)
  @size = 1024

  tests('Upload and manipulate a disk') do
    tests('#post_upload_disk').data_matches_schema(VcloudDirector::Compute::Schema::DISK_TYPE) do
      @vdc_id = VcloudDirector::Compute::Helper.first_vdc_id(@org)
      @disk = @service.post_upload_disk(@vdc_id, @disk_name, @size).body
    end
    @service.process_task(@disk[:Tasks][:Task])
    @disk_id = @disk[:href].split('/').last

    tests("#get_disk(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::DISK_TYPE) do
      @disk = @service.get_disk(@disk_id).body
    end
    tests("disk[:name]").returns(@disk_name) { @disk[:name] }
    tests("disk[:size]").returns(@size) { @disk[:size].to_i }

    tests("#get_disk_owner(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::OWNER_TYPE) do
      @owner = @service.get_disk_owner(@disk_id).body
    end
    tests("owner[:User][:name]").returns(@service.user_name) { @owner[:User][:name] }

    #tests("#put_disk(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
    #  @disk_name += '-renamed'
    #  @task = @service.put_disk(@disk_id, @disk_name).body
    #end
    #@service.process_task(@task)
    #tests("#get_disk(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::DISK_TYPE) do
    #  @disk = @service.get_disk(@disk_id).body
    #end
    #tests("disk[:name]").returns(@disk_name) { @disk[:name] }
    #tests("disk[:size]").returns(@size) { @disk[:size].to_i } # shouldn't change

    tests('disk metadata') do
      pending if Fog.mocking?

      tests("#put_disk_metadata_item_metadata(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
        @task = @service.put_disk_metadata_item_metadata(@disk_id, 'fog-test-key', 'fog-test-value').body
      end
      @service.process_task(@task)

      tests("#put_disk_metadata_item_metadata(#{@disk_id})") do
        tests("#put_disk_metadata_item_metadata(Boolean)").returns(true) do
          task = @service.put_disk_metadata_item_metadata(@disk_id, 'fog-test-boolean', true).body
          @service.process_task(task)
        end
        tests("#put_disk_metadata_item_metadata(DateTime)").returns(true) do
          task = @service.put_disk_metadata_item_metadata(@disk_id, 'fog-test-datetime', DateTime.now).body
          @service.process_task(task)
        end
        tests("#put_disk_metadata_item_metadata(Number)").returns(true) do
          task = @service.put_disk_metadata_item_metadata(@disk_id, 'fog-test-number', 111).body
          @service.process_task(task)
        end
      end

      tests("#post_update_disk_metadata(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
        metadata = {
          'fog-test-key-update' => 'fog-test-value-update',
          'fog-test-boolean-update' => false,
          'fog-test-datetime-update' => DateTime.now,
          'fog-test-number-update' => 222
        }
        @task = @service.post_update_disk_metadata(@disk_id, metadata).body
      end
      @service.process_task(@task)

      tests("#get_disk_metadata(#{@disk_id})") do
        tests('response format').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
          @metadata = @service.get_disk_metadata(@disk_id).body
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

    tests("#get_vms_disk_attached_to(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::VMS_TYPE) do
      pending if Fog.mocking?
      @service.get_vms_disk_attached_to(@disk_id).body
    end

    tests("#delete_disk(#{@disk_id})").data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
      @task = @service.delete_disk(@disk_id).body
    end
    @service.process_task(@task)
  end

  tests('Disk no longer exists') do
    tests("#get_disk(#{@disk_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_disk(@disk_id)
    end
    tests("#get_disk_owner(#{@disk_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_disk_owner(@disk_id)
    end
    tests("#get_disk_metadata(#{@disk_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      pending if Fog.mocking?
      @service.get_disk_metadata(@disk_id)
    end
    tests("#delete_disk(#{@disk_id})").raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.delete_disk(@disk_id)
    end
  end

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

end
