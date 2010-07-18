Shindo.tests('Linode | linode requests', ['linode']) do

  @linode_format = Linode::Formats::BASIC.merge({
    'DATA' => { 'LinodeID' => Integer }
  })

  @linodes_format = Linode::Formats::BASIC.merge({
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

  @reboot_format = Linode::Formats::BASIC.merge({
    'DATA' => { 'JobID' => Integer }
  })

  tests('success') do

    @linode_id = nil

    # (2 => Dallas, TX, USA), (1 => 1 month), (1 => Linode 512)
    tests('#linode_create(2, 1, 1)').formats(@linode_format) do
      data = Linode[:linode].linode_create(2, 1, 1).body
      @linode_id = data['DATA']['LinodeID']
      data
    end

    tests("#linode_list(#{@linode_id})").formats(@linodes_format) do
      Linode[:linode].linode_list(@linode_id).body
    end

    tests('#linode_list').formats(@linodes_format) do
      Linode[:linode].linode_list.body
    end

    # tests("#linode_reboot(#{@linode_id})").formats(@reboot_format) do
    #   Linode[:linode].linode_reboot(@linode_id).body
    # end

    tests('#linode_delete(#{@linode_id})').succeeds do
      Linode[:linode].linode_delete(@linode_id)
    end

  end

  tests('failure') do

    tests('#linode_reboot(0)').raises(Fog::Linode::NotFound) do
      Linode[:linode].linode_reboot(0)
    end

    tests('#linode_delete(0)').raises(Fog::Linode::NotFound) do
      Linode[:linode].linode_delete(0)
    end

  end

end
