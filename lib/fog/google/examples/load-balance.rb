
def test
  # Config
  name = "fog-lb-test-#{Time.now.to_i}"
  zone = 'us-central1-b'
  region = 'us-central1'

  # Setup
  gce = Fog::Compute.new provider: 'Google'
  servers = []

  (1..3).each do |i|
    begin
      disk = gce.disks.create(
        name: "#{name}-#{i}",
        size_gb: 10,
          zone_name: zone,
          source_image: 'debian-7-wheezy-v20131120'
      )
      disk.wait_for { disk.ready? }
    rescue
      puts "Failed to create disk #{name}-#{i}"
    end

    begin
      server = gce.servers.create(
        name: "#{name}-#{i}",
        disks: [ disk.get_as_boot_disk(true, true) ],
          machine_type: 'f1-micro',
          zone_name: zone
      )
      servers << server
    rescue
      puts "Failed to create instance #{name}-#{i}"
    end
  end

  begin
    health = gce.http_health_checks.new(name: name)
    health.save
  rescue
    puts "Failed to create health check #{name}"
  end

  begin
    pool = gce.target_pools.new(
      name: name,
      region: region,
      health_checks: health.self_link,
      instances: servers.map(&:self_link)
    )
    pool.save
  rescue
    puts "Failed to create target pool #{name}"
  end

  begin
    rule = gce.forwarding_rules.new(
      name: name,
      region: region,
      port_range: '1-65535',
      ip_protocol: 'TCP',
      target: pool.self_link
    )
    rule.save
  rescue
    puts "Failed to create forwarding rule #{name}"
  end


  # TODO(bensonk): Install apache, create individualized htdocs, and run some
  #                actual requests through the load balancer.

  # Cleanup
  begin
    rule.destroy
  rescue
    puts "Failed to clean up forwarding rule."
  end

  begin
    pool.destroy
  rescue
    puts "Failed to clean up target pool."
  end

  begin
    health.destroy
  rescue
    puts "Failed to clean up health check."
  end

  begin
    servers.each &:destroy
  rescue
    puts "Failed to clean up instances."
  end
end
