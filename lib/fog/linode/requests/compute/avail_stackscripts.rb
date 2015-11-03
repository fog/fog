module Fog
  module Compute
    class Linode
      class Real
        def avail_stackscripts(options={})
          result = request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'avail.stackscripts' }.merge!(options)
          )
          result.body['DATA'].each { |r| r['DISTRIBUTIONIDLIST'] = r['DISTRIBUTIONIDLIST'].to_s }
          result
        end
      end

      class Mock
        def avail_stackscripts(options={})
          response = Excon::Response.new
          response.status = 200

          body = {
            "ERRORARRAY" => [],
            "ACTION" => "avail.stackscripts"
          }
          mock_stackscripts = []
          10.times do
            stackscript_id = rand(1..200)
            mock_stackscripts << create_mock_stackscript(stackscript_id)
          end
          response.body = body.merge("DATA" => mock_stackscripts)
          response
        end

        private

        def create_mock_stackscript(stackscript_id)
          {
            "CREATE_DT"          => "2011-10-07 00:28:13.0",
            "DEPLOYMENTSACTIVE"  => 0,
            "DEPLOYMENTSTOTAL"   => 1,
            "DESCRIPTION"        => "Prints 'foobar' to the screen. Magic!",
            "DISTRIBUTIONIDLIST" => "77,78,64,65,82,83,50,51,73,74,41,42",
            "ISPUBLIC"           => 1,
            "LABEL"              => "foobar",
            "LATESTREV"          => 15149,
            "REV_DT"             => "2011-10-07 00:33:58.0",
            "REV_NOTE"           => "Updated update_rubygems_install function.",
            "SCRIPT"             => "#!/bin/bash\n#\n#\n\necho \"foobar\"",
            "STACKSCRIPTID"      => stackscript_id,
            "USERID"             => 1
          }
        end
      end
    end
  end
end
