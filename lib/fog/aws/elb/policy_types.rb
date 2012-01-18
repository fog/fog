class Fog::AWS::ELB::Mock
  POLICY_TYPES = [{
    "Description" => "",
    "PolicyAttributeTypeDescriptions" => [{
      "AttributeName"=>"CookieName",
      "AttributeType"=>"String",
      "Cardinality"=>"ONE",
      "DefaultValue"=>"",
      "Description"=>""
    }],
    "PolicyTypeName"=>"AppCookieStickinessPolicyType"
  },
  {
    "Description" => "",
    "PolicyAttributeTypeDescriptions" => [{
      "AttributeName"=>"CookieExpirationPeriod",
      "AttributeType"=>"String",
      "Cardinality"=>"ONE",
      "DefaultValue"=>"",
      "Description"=>""
    }],
    "PolicyTypeName"=>"LBCookieStickinessPolicyType"
  },
  {
    "Description" => "Policy containing a list of public keys to accept when authenticating the back-end server(s). This policy cannot be applied directly to back-end servers or listeners but must be part of a BackendServerAuthenticationPolicyType.",
    "PolicyAttributeTypeDescriptions" => [{
      "AttributeName"=>"PublicKey",
      "AttributeType"=>"String",
      "Cardinality"=>"ONE",
      "DefaultValue"=>"",
      "Description"=>""
    }],
    "PolicyTypeName"=>"PublicKeyPolicyType"
  }]
end
