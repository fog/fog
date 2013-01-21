Shindo.tests('Fog::Compute[:brightbox] | firewall policy requests', ['brightbox']) do

  tests('success') do
    pending if Fog.mocking?

    create_options = {
      :name => "Fog test policy A"
    }

    tests("#create_firewall_policy(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_firewall_policy(create_options)
      @firewall_policy_id = result["id"]
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) { result }
    end

    tests("#list_firewall_policies()") do
      formats(Brightbox::Compute::Formats::Collection::FIREWALL_POLICIES, false) do
        Fog::Compute[:brightbox].list_firewall_policies
      end
    end

    tests("#get_firewall_policy('#{@firewall_policy_id}')") do
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) do
        Fog::Compute[:brightbox].get_firewall_policy(@firewall_policy_id)
      end
    end

    update_options = {:name => "Fog test policy B"}
    tests("#update_firewall_policy('#{@firewall_policy_id}', #{update_options.inspect})") do
      result = Fog::Compute[:brightbox].update_firewall_policy(@firewall_policy_id, update_options)
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) { result }
      returns("Fog test policy B") { result["name"] }
    end

    tests("#destroy_firewall_policy('#{@firewall_policy_id}')") do
      result = Fog::Compute[:brightbox].destroy_firewall_policy(@firewall_policy_id)
      formats(Brightbox::Compute::Formats::Full::FIREWALL_POLICY, false) { result }
    end
  end
end
