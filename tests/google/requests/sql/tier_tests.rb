Shindo.tests('Fog::Google[:sql] | tier requests', ['google']) do
  @sql = Fog::Google[:sql]

  @get_tier_format = {
    'tier' => String,
    'DiskQuota' => String,
    'kind' => String,
    'RAM' => String,
    'region' => Array,
  }

  @list_tiers_format = {
    'kind' => String,
    'items' => [@get_tier_format],
  }

  tests('success') do

    tests('#list_tiers').formats(@list_tiers_format) do
      @sql.list_tiers.body
    end

  end

end
