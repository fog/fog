# Testing the Dreamhost DNS API

Dreamhost API sandbox only permits read-only commands, so you'll need a Dreamhost
PS account for the testing and a dedicated domain.

See http://wiki.dreamhost.com/Application_programming_interface#Test_Account

## Create an API key

You'll need a Dreamhost (PS I think) account and a dedicated domain for testing.

1. Go to the Dreamhost web panel and create an API key to manage DNS records

   https://panel.dreamhost.com/index.cgi?tree=home.api

   Select 'All dns functions' for the new API key to be able to add/remove/list
records.

2. Create a .fog file in the tests/ directory with the following contents:

   ```yaml
   :default:
     :dreamhost_api_key: SDFASDFWQWASDFASDFAS
   ```
   Where dreamhost_api_key is the key you created in the previous step.

3. Update the test_domain helper in tests/dreamhost/helper.rb to use your own 
   domain for testing. You will also need at least a record created via
   the Dreamhost Webpanel (you'll get a **no_such_zone** error otherwise).

   I usually create a do-not-delete.my-domain.com record. The tests skip that
   record when cleaning up (see the do_not_delete_record helper).

4. Run the tests

   ```
   shindo tests/dreamhost
   ```
   
## Notes

The API is rate limited, so do not smash the DH servers too often. Two
consecutive test runs will trigger the rate limit.
You'll see a **slow_down_bucko** error if the frequency is too high.

http://wiki.dreamhost.com/Application_programming_interface#Rate_Limit

## Resources

Dreamhost API:

http://wiki.dreamhost.com/Application_programming_interface

Dreamhost DNS API:

http://wiki.dreamhost.com/API/Dns_commands
