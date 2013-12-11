Shindo.tests('Fog::Compute[:brightbox] | firewall rule requests', ['brightbox']) do

  tests('success') do
    pending if Fog.mocking?

    unless Fog.mocking?
      policy = Fog::Compute[:brightbox].firewall_policies.create
    end

    create_options = {
      :firewall_policy => policy.id,
      :destination => "127.0.0.1"
    }

    tests("#create_firewall_rule(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_firewall_rule(create_options)
      @firewall_rule_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_RULE, {:allow_extra_keys => true}) { result }
    end

    tests("#get_firewall_rule('#{@firewall_rule_id}')") do
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_RULE, {:allow_extra_keys => true}) do
        Fog::Compute[:brightbox].get_firewall_rule(@firewall_rule_id)
      end
    end

    update_options = {:source => nil, :destination => "127.0.0.1"}
    tests("#update_firewall_rule('#{@firewall_rule_id}', #{update_options.inspect})") do
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_RULE, {:allow_extra_keys => true}) do
        Fog::Compute[:brightbox].update_firewall_rule(@firewall_rule_id, update_options)
      end
    end

    tests("#destroy_firewall_rule('#{@firewall_rule_id}')") do
      result = Fog::Compute[:brightbox].destroy_firewall_rule(@firewall_rule_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_RULE, {:allow_extra_keys => true}) { result }
    end

    unless Fog.mocking?
      policy.destroy
    end
  end
end
