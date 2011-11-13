Shindo.tests('AWS::STS | session tokens', ['aws']) do

	@session_format = {
		'SessionToken' => String,
		'SecretAccessKey' => String,
		'Expiration' => String,
		'AccessKeyId' => String,
		'RequestId'	=> String
	}

	tests("#get_session_token").formats(@session_format) do
		pending if Fog.mocking?
		Fog::AWS[:sts].get_session_token.body
	end
	
	@policy = {"Statement" => [{"Effect" => "Allow", "Action" => "*", "Resource" => "*"}]}

	@federation_format = {
		'SessionToken' => String,
		'SecretAccessKey' => String,
		'Expiration' => String,
		'AccessKeyId' => String,
		'Arn' => String,
		'FederatedUserId' => String,
		'PackedPolicySize' => String,
		'RequestId'	=> String
	}

	tests("#get_federation_token('test@fog.io', #{@policy.inspect})").formats(@federation_format) do
		pending if Fog.mocking?
		Fog::AWS[:sts].get_federation_token("test@fog.io", @policy).body
	end
	
end
