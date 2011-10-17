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
    'DATA' => { 'IPAddressID' => Integer }
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

  @disk_format = Linode::Compute::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer, 'DiskID' => Integer }
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
      Fog::Compute[:linode].linode_update(@linode_id, :label => 'testing').body
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

    tests('#linode_disk_createfromdistribution').formats(@disk_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:linode].linode_disk_createfromdistribution(@linode_id, 73, 'test1', 600, 'P@SSW)RD').body
      @disk2_id = data['DATA']['DiskID']
      data
    end

    tests('#linode_disk_list').formats(@disks_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_list(@linode_id).body
    end

    # tests("#linode_reboot(#{@linode_id})").formats(@reboot_format) do
    #   Fog::Compute[:linode].linode_reboot(@linode_id).body
    # end    

    tests('#linode_disk_delete').formats(@disk_format) do
      pending if Fog.mocking?
      Fog::Compute[:linode].linode_disk_delete(@linode_id, @disk1_id).body
      Fog::Compute[:linode].linode_disk_delete(@linode_id, @disk2_id).body
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
