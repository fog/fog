Shindo.tests('Fog::Compute[:brightbox] | firewall policy requests', ['brightbox']) do

  tests('success') do
    pending if Fog.mocking?

    create_options = {
      :name => "Fog test policy A"
    }

    tests("#create_firewall_policy(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_firewall_policy(create_options)
      @firewall_policy_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, {:allow_extra_keys => true}) { result }
    end

    tests("#list_firewall_policies()") do
      data_matches_schema(Brightbox::Compute::Formats::Collection::FIREWALL_POLICIES, {:allow_extra_keys => true}) do
        Fog::Compute[:brightbox].list_firewall_policies
      end
    end

    tests("#get_firewall_policy('#{@firewall_policy_id}')") do
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, {:allow_extra_keys => true}) do
        Fog::Compute[:brightbox].get_firewall_policy(@firewall_policy_id)
      end
    end

    update_options = {:name => "Fog test policy B"}
    tests("#update_firewall_policy('#{@firewall_policy_id}', #{update_options.inspect})") do
      result = Fog::Compute[:brightbox].update_firewall_policy(@firewall_policy_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, {:allow_extra_keys => true}) { result }
      returns("Fog test policy B") { result["name"] }
    end

    tests("#destroy_firewall_policy('#{@firewall_policy_id}')") do
      result = Fog::Compute[:brightbox].destroy_firewall_policy(@firewall_policy_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, {:allow_extra_keys => true}) { result }
    end
  end
end
