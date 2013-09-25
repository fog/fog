provider, config = :ecloud, compute_providers[:ecloud]

Shindo.tests("Fog::Compute[:#{provider}] | detached_disks", [provider.to_s]) do
  connection = Fog::Compute[provider]
  @organization   = connection.organizations.first
  @environment    = @organization.environments.first
  @compute_pool   = @environment.compute_pools.first
  @detached_disks = @compute_pool.detached_disks

  tests('#all').succeeds do
    if @detached_disks.is_a?(Fog::Compute::Ecloud::DetachedDisks) && @detached_disks.reload.empty?
      returns(true, "compute pool has no detached disks") { @detached_disks.all.empty? }
    else
      returns(false, "has detached disks") { @detached_disks.all.empty? }
    end
  end

  unless @detached_disks.empty?
    tests('#get') do
      disk = @detached_disks.first
      fetched_disk = connection.detached_disks.get(disk.href)
      returns(false, "disk is not nil") { fetched_disk.nil? }
      returns(true, "is a DetachedDisk") { fetched_disk.is_a?(Fog::Compute::Ecloud::DetachedDisk) }
    end
  end
end
