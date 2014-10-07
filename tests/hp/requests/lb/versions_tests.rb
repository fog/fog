Shindo.tests("HP::LB | versions requests", ['hp', 'lb', 'versions']) do
  @version_format = {
    'id'        => String,
    'links'     => [Hash],
    'status'    => String,
    'updated'   => String
  }

  tests('success') do

    tests('#list_versions').formats({'versions' => [@version_format]}) do
      HP[:lb].list_versions.body
    end
  end

end
