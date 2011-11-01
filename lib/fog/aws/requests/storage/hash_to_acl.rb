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
            case grant['Grantee'].keys.sort
            when ['DisplayName', 'ID']
              data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"CanonicalUser\">\n"
              data << "        <ID>#{grant['Grantee']['ID']}</ID>\n"
              data << "        <DisplayName>#{grant['Grantee']['DisplayName']}</DisplayName>\n"
              data << "      </Grantee>\n"
            when ['EmailAddress']
              data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"AmazonCustomerByEmail\">\n"
              data << "        <EmailAddress>#{grant['Grantee']['EmailAddress']}</EmailAddress>\n"
              data << "      </Grantee>\n"
            when ['URI']
              data << "      <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"Group\">\n"
              data << "        <URI>#{grant['Grantee']['URI']}</URI>\n"
              data << "      </Grantee>\n"
            end
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

