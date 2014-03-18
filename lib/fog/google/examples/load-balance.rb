
def test
  # Config
  name = "fog-lb-test-#{Time.now.to_i}"
  zone = 'us-central1-b'
  region = 'us-central1'


  # Setup
  gce = Fog::Compute.new provider: 'Google'
  servers = []
  disks = []

  (1..3).each do |i|
    puts "Creating disk #{name}-#{i}"
    disk = gce.disks.create(
      name: "#{name}-#{i}",
      size_gb: 10,
      auto_delete: true,
      zone_name: zone,
      source_image: 'debian-7-wheezy-v20131120'
    )
    disk.wait_for { disk.ready? }
    disk.reload
    disks << disk
  
    puts "Creating server #{name}-#{i}"
    server = gce.servers.create(
      name: "#{name}-#{i}",
      disks: [disk],
      machine_type: 'f1-micro',
      zone_name: zone
    )
    servers << server
  end

  puts "Creating health check #{name}"
  health = gce.http_health_checks.new(name: name)
  health.save
  health.reload

  puts "Creating health check #{name}"
  pool = gce.target_pools.new(
    name: name,
    region: region,
    health_checks: health.self_link,
    instances: servers.map(&:self_link)
  )
  pool.save
  pool.reload

  puts "Creating forwarding rule #{name}"
  rule = gce.forwarding_rules.new(
    name: name,
    region: region,
    port_range: '1-65535',
    ip_protocol: 'TCP',
    target: pool.self_link
  )
  rule.save
  rule.reload

  
  # TODO(bensonk): Install apache, create individualized htdocs, and run some
  #                actual requests through the load balancer.


  # Cleanup
  puts 'Destroying forwarding rule'
  rule.destroy
  puts 'Destroying target pool'
  pool.destroy
  puts 'Destroying health check'
  health.destroy
  puts 'Destroying servers and disks'
  servers.each &:destroy

  # TODO(bensonk): make auto_delete work correctly
  sleep 40
  disks.each &:destroy
end
