Shindo.tests("HP::DNS | list domains tests", ['hp', 'dns', 'domain']) do
  @domain_format = {
      "id"     => String,
      "name"   => String,
      "ttl"    => Integer,
      "serial" => Integer,
      "email"  => String,
      "created_at" => String
  }

  tests('success') do
    tests('#list_domains').formats({'domains' => [@domain_format]}) do
      HP[:dns].list_domains.body
    end
  end

end