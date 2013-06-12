Shindo.tests('Fog::Volume[:openstack] | backups', ['openstack']) do
  @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                   :display_description => 'Test Volume',
                                                   :size => 1)
  @volume.wait_for { status == 'available' } if @volume
  
  @backup = Fog::Volume[:openstack].backups.create(:volume_id => @volume.id,
                                                   :name => 'test-backup',
                                                   :description => 'Test Backup')
  @backup.wait_for { status == 'available' } if @backup
  
  @backups = Fog::Volume[:openstack].backups

  tests('success') do
    tests('#all').succeeds do
      @backups.all
    end

    tests('#get').succeeds do
      @backups.get @backup.id
    end
  end

  @backup.destroy if @backup
  Fog.wait_for { @backup.reload.nil? } if @backup      
    
  @volume.destroy if @volume
  Fog.wait_for { @volume.reload.nil? } if @volume
end