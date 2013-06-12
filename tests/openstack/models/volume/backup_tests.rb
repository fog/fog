Shindo.tests('Fog::Volume[:openstack] | backup', ['openstack']) do
  @volume = Fog::Volume[:openstack].volumes.create(:display_name => 'test-volume',
                                                   :display_description => 'Test Volume',
                                                   :size => 1)
  @volume.wait_for { status == 'available' } if @volume
  
  tests('success') do
    tests('#create').succeeds do
      @backup = Fog::Volume[:openstack].backups.create(:volume_id => @volume.id,
                                                       :name => 'test-backup',
                                                       :description => 'Test Backup')
      !@backup.id.nil?
    end

    @backup.wait_for { status == 'available' } if @backup
    
    tests('#restore').succeeds do
      @backup.restore(@volume.id) == true
    end
    
    @backup.wait_for { status == 'available' } if @backup
    
    tests('#destroy').succeeds do
      @backup.destroy == true
    end
  end

  Fog.wait_for { @backup.reload.nil? } if @backup

  @volume.destroy if @volume
  Fog.wait_for { @volume.reload.nil? } if @volume  
end