module Fog
  module Storage
    class AWS
      private
        def self.hash_to_acl(acl)
          data =
<<-DATA
<AccessControlPolicy>
  <Owner>
    <ID>#{acl['Owner']['ID']}</ID>
    <DisplayName>#{acl['Owner']['DisplayName']}</DisplayName>
  </Owner>
  <AccessControlList>
DATA

          acl['AccessControlList'].each do |grant|
            data << "    <Grant>\n"
            type = case grant['Grantee'].keys.sort
            when ['DisplayName', 'ID']
              'CanonicalUser'
            when ['EmailAddress']
              'AmazonCustomerByEmail'
            when ['URI']
              'Group'
            end
            data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"#{type}\">\n"
            for key, value in grant['Grantee']
              data << "        <#{key}>#{value}</#{key}>\n"
            end
            data << "      </Grantee>\n"
            data << "      <Permission>#{grant['Permission']}</Permission>\n"
            data << "    </Grant>\n"
          end
          
          data <<
<<-DATA
  </AccessControlList>
</AccessControlPolicy>
DATA
          data
        end
    end
  end      
end

