Shindo.tests('Fog::Compute[:linode] | linode requests', ['linode']) do

  @linode_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'LinodeID' => Integer }
  })

  @linodes_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      'ALERT_BWIN_ENABLED'      => Integer,
      'ALERT_CPU_THRESHOLD'     => Integer,
      'ALERT_BWOUT_ENABLED'     => Integer,
      'ALERT_BWOUT_THRESHOLD'   => Integer,
      'ALERT_BWQUOTA_ENABLED'   => Integer,
      'ALERT_BWQUOTA_THRESHOLD' => Integer,
      'ALERT_BWIN_THRESHOLD'    => Integer,
      'ALERT_CPU_ENABLED'       => Integer,
      'ALERT_DISKIO_ENABLED'    => Integer,
      'ALERT_DISKIO_THRESHOLD'  => Integer,
      'BACKUPSENABLED'          => Integer,
      'BACKUPWEEKLYDAY'         => Integer,
      'BACKUPWINDOW'            => Integer,
      'DATACENTERID'            => Integer,
      'LABEL'                   => String,
      'LINODEID'                => Integer,
      'LPM_DISPLAYGROUP'        => String,
      'STATUS'                  => Integer,
      'TOTALHD'                 => Integer,
      'TOTALRAM'                => Integer,
      'TOTALXFER'               => Integer,
      'WATCHDOG'                => Integer,
    }]
  })

  @reboot_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer }
  })

  @ip_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'IPADDRESSID' => Integer, 'IPADDRESS' => String }
  })

  @disks_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      "UPDATE_DT"  => String,
      "DISKID"     => Integer,
      "LABEL"      => String,
      "TYPE"       => String,
      "LINODEID"   => Integer,
      "ISREADONLY" => Integer,
      "STATUS"     => Integer,
      "CREATE_DT"  => String,
      "SIZE"       => Integer
    }]
  })

  @images_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => [{
      "LAST_USED_DT" => String,
      "DESCRIPTION"  => String,
      "LABEL"        => String,
      "STATUS"       => String,
      "TYPE"         => String,
      "MINSIZE"      => Integer,
      "ISPUBLIC"     => Integer,
      "CREATE_DT"    => String,
      "FS_TYPE"      => String,
      "CREATOR"       => String,
      "IMAGEID"      => Integer
    }]
  })

  @disk_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer, 'DiskID' => Integer }
  })

  @disk_createfromimage_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JOBID' => Integer, 'DISKID' => Integer }
  })

  @disk_resize_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer }
  })

  @disk_imagize_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer, 'ImageID' => Integer }
  })

  @disk_update_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'DiskID' => Integer }
  })

  tests('success') do

    @linode_id = nil

    # (2 => Dallas, TX, USA), (1 => 1 month), (1 => Linode 512)
    tests('#linode_create(2, 1, 1)').formats(@linode_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_create(2, 1, 1).body
      @linode_id = data['DATA']['LinodeID']
      data
    end

    tests("#linode_list(#{@linode_id})").formats(@linodes_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_list(@linode_id).body
    end

    tests('#linode_list').formats(@linodes_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_list.body
    end

    tests('#linode_update').formats(@linode_format) do
      pending if Fog.mocking?
      rand_label = 'testing' + Fog::Mock.random_letters(6)
      Fog::Compute[:linode].linode_update(@linode_id, :label => rand_label).body
    end

    tests('#linode_ip_addprivate').formats(@ip_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_ip_addprivate(@linode_id).body
    end

    tests('#linode_disk_create').formats(@disk_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_disk_create(@linode_id, 'test1', 'ext3', 1).body
      @disk1_id = data['DATA']['DiskID']
      data
    end

    tests('#linode_disk_update').formats(@disk_update_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_update(@linode_id, @disk1_id, 'test1-updated', 1).body
    end

    tests('#linode_disk_duplicate').formats(@disk_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_duplicate(@linode_id, @disk1_id).body
    end

    tests('#linode_disk_resize').formats(@disk_resize_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_resize(@linode_id, @disk1_id, 2).body
    end

    tests('#linode_disk_imagize').formats(@disk_imagize_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_disk_imagize(@linode_id, @disk1_id, 'test description imageid1', 'test label imageid1').body
      @image1_id = data['DATA']['ImageID']
      data
    end

    tests('#linode_disk_createfromdistribution').formats(@disk_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_disk_createfromdistribution(@linode_id, 124, 'test1', 750, 'P@SSW)RD').body
      @disk2_id = data['DATA']['DiskID']
      data
    end

    tests('#linode_disk_createfromimage').formats(@disk_createfromimage_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_disk_createfromimage(@linode_id, @image1_id, 'test1', 3, 'P@SSW)RD', '').body
      @disk3_id = data['DATA']['DISKID']
      data
    end

    tests('#image_list').formats(@images_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].image_list(@image_id).body
    end

    tests('#linode_disk_list').formats(@disks_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_list(@linode_id).body
    end

    # tests("#linode_reboot(#{@linode_id})").formats(@reboot_format) do
    #   Fog::Compute[:linode].linode_reboot(@linode_id).body
    # end

    tests('#image_delete').formats(@images_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].image_delete(@image1_id).body
    end

    tests('#linode_disk_delete').formats(@disk_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_delete(@linode_id, @disk1_id).body
      Fog::Compute[:linode].linode_disk_delete(@linode_id, @disk2_id).body
      Fog::Compute[:linode].linode_disk_delete(@linode_id, @disk3_id).body
    end

    tests('#linode_delete(#{@linode_id})').succeeds do
      pending if Fog.mocking?
      sleep 1 until Fog::Compute[:linode].linode_disk_list(@linode_id).body['DATA'].size == 0
      Fog::Compute[:linode].linode_delete(@linode_id)
    end

  end

  tests('failure') do

    tests('#linode_reboot(0)').raises(Fog::Compute::Linode::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_reboot(1)
    end

    tests('#linode_delete(0)').raises(Fog::Compute::Linode::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_delete(1)
    end

  end

end
