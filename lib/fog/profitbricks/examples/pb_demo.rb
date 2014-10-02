require 'fog'

Excon.defaults[:connection_timeout] = 200

compute = Fog::Compute.new(:provider => 'ProfitBricks')

# Create data center
datacenter = compute.datacenters.create(:name => 'MyDataCenter', :region => 'us/las')
datacenter.wait_for { ready? }

# Get the data center
compute.datacenters.get(datacenter.id)

# List all data centers
compute.datacenters.all

# Update the data center
datacenter.options = { :dataCenterName => 'TestDataCenter'}
datacenter.update
datacenter.wait_for { ready? }

# Refresh data center properties
datacenter.reload

# Find HDD image in North America running Linux
image = compute.images.all.find do |image|
    image.region    == 'us/las' &&
    image.type      == 'HDD' &&
    image.os_type   == 'LINUX'
end

# Create volume
volume = compute.volumes.create(:data_center_id => datacenter.id, :size => 5, :options => { :storageName => 'MyVolume', :mountImageId => image.id })
volume.wait_for { ready? }

# Create server
server = compute.servers.create(:data_center_id => datacenter.id, :cores => 1, :ram => 1024, :options => { :serverName => 'MyServer' })
server.wait_for { ready? }

# Attach volume to server
volume.attach(server.id)

# Create network interface and attach to server
nic = compute.interfaces.create(:server_id => server.id, :lan_id => 1, :options => { :nicName => 'TestNic', :ip => '10.0.0.1', :dhcpActive => false })

# Enable LAN for public Internet access
nic.set_internet_access(:data_center_id => datacenter.id, :lan_id => 1, :internet_access => true)

# Clear data center (WARNING - this will remove all items under a data center)
datacenter.clear(true)

# Delete data center
datacenter.destroy
