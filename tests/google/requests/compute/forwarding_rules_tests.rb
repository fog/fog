Shindo.tests('Fog::Compute[:google] | forwarding rule requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_forwarding_rule_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'region' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_forwarding_rule_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'region' => String,
      'IPAddress' => String,
      'IPProtocol' => String,
      'portRange' => String,
      'target' => String
  }

  @delete_forwarding_rule_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'region' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_forwarding_rules_format = {
      'kind' => String,
      'id' => String,
      'items' => Array,
      'selfLink' => String
  }

  tests('success') do

    forwarding_rule_name = 'test-forwarding-rule'
    region_name = 'us-central1'
    # These will all fail if errors happen on insert
    tests("#insert_forwarding_rule").formats(@insert_forwarding_rule_format) do
      target = create_test_target_pool(Fog::Compute[:google], region_name)
      options = { 'target' => target.self_link }
      response = @google.insert_forwarding_rule(forwarding_rule_name, region_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_forwarding_rule").formats(@get_forwarding_rule_format) do
      @google.get_forwarding_rule(forwarding_rule_name, region_name).body
    end

    tests("#list_forwarding_rules").formats(@list_forwarding_rules_format) do
      @google.list_forwarding_rules(region_name).body
    end

    tests("#delete_forwarding_rule").formats(@delete_forwarding_rule_format) do
      @google.delete_forwarding_rule(forwarding_rule_name, region_name).body
    end

  end

end
