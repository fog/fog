Shindo.tests('Fog::Compute[:brightbox] | user collaboration requests', ['brightbox']) do

  @service = Fog::Compute[:brightbox]

  tests("when accessing with user application") do
    pending unless @service.authenticating_as_user?
    tests("success") do
      tests("#list_user_collaborations") do
        pending if Fog.mocking?
        result = @service.list_user_collaborations

        formats(Brightbox::Compute::Formats::Collection::COLLABORATIONS, false) { result }
      end
    end

    tests("failure") do
      tests("get_user_collaboration('col-abcde')").raises(Excon::Errors::NotFound) do
        pending if Fog.mocking?

        @service.get_user_collaboration('col-abcde')
      end

      tests("accept_user_collaboration('col-abcde')").raises(Excon::Errors::NotFound) do
        pending if Fog.mocking?

        @service.accept_user_collaboration('col-abcde')
      end

      tests("reject_user_collaboration('col-abcde')").raises(Excon::Errors::NotFound) do
        pending if Fog.mocking?

        @service.reject_user_collaboration('col-abcde')
      end
    end
  end

  tests("when accessing with API client") do
    pending if @service.authenticating_as_user?
    tests("forbidden") do

      tests("#list_user_collaborations").raises(Excon::Errors::Forbidden) do
        pending if Fog.mocking?
        result = @service.list_user_collaborations

        formats(Brightbox::Compute::Formats::Collection::COLLABORATIONS, false) { result }
      end

      tests("get_user_collaboration('col-abcde')").raises(Excon::Errors::Forbidden) do
        pending if Fog.mocking?

        @service.get_user_collaboration('col-abcde')
      end

      tests("accept_user_collaboration('col-abcde')").raises(Excon::Errors::Forbidden) do
        pending if Fog.mocking?

        @service.accept_user_collaboration('col-abcde')
      end

      tests("reject_user_collaboration('col-abcde')").raises(Excon::Errors::Forbidden) do
        pending if Fog.mocking?

        @service.reject_user_collaboration('col-abcde')
      end
    end
  end
end
