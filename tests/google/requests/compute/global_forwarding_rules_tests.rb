Shindo.tests('Fog::Compute[:google] | global forwarding rule requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_global_forwarding_rule_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'zone' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_global_forwarding_rule_format = {
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

  @delete_global_forwarding_rule_format = {
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
      'zone' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_global_forwarding_rules_format = {
      'kind' => String,
      'id' => String,
      'items' => Array,
      'selfLink' => String
  }

  tests('success') do

    global_forwarding_rule_name = 'test-global-forwarding-rule'

    # These will all fail if errors happen on insert
    tests("#insert_global_forwarding_rule").formats(@insert_global_forwarding_rule_format) do
      target = create_test_target_http_proxy(Fog::Compute[:google])
      options = { 'target' => target.self_link }
      response = @google.insert_global_forwarding_rule(global_forwarding_rule_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_global_forwarding_rule").formats(@get_global_forwarding_rule_format) do
      @google.get_global_forwarding_rule(global_forwarding_rule_name).body
    end

    tests("#list_global_forwarding_rules").formats(@list_global_forwarding_rules_format) do
      @google.list_global_forwarding_rules('global').body
    end

    tests("#delete_global_forwarding_rule").formats(@delete_global_forwarding_rule_format) do
      @google.delete_global_forwarding_rule(global_forwarding_rule_name).body
    end

  end

end
