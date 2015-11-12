module Fog
  module Compute
    class CloudSigma
      class Mock
        def self.mock_data
          {
            :volumes => {},
            :servers => {},
            :vlans => {},
            :ips => {},
            :profile => {
              :login_sms => false,
              :town => "",
              :postcode => "",
              :reseller => "",
              :has_autotopup => false,
              :currency => "CHF",
              :state => "REGULAR",
              :uuid => "6c2203a1-a2e6-433f-aeab-b976b8cd3d18",
              :company => "",
              :api_https_only => false,
              :my_notes => "",
              :key_auth => false,
              :email => "MyFirstName.MyLasttName@MyCompany.com",
              :bank_reference => "mmlastname278",
              :first_name => "MyFirstName",
              :meta =>"",
              :phone => "",
              :language => "EN",
              :vat => "",
              :last_name => "MyLasttName",
              :title => "",
              :mailing_list => true,
              :autotopup_amount => 0.0,
              :country => "",
              :address => ""
            },
            :subscriptions => {},
            :current_usage => {},
            :balance => {
              :balance => 100,
              :currency => 'CHF'
            }
          }
        end
      end
    end
  end
end
