module Fog
  module Google
    class SQL
      ##
      # Creates an SSL certificate. The new certificate will not be usable until the instance is restarted.
      #
      # @see https://developers.google.com/cloud-sql/docs/admin-api/v1beta3/sslCerts/insert

      class Real
        def insert_ssl_cert(instance_id, common_name)
          api_method = @sql.ssl_certs.insert
          parameters = {
            'project' => @project,
            'instance' => instance_id,
          }

          body = {
            'commonName' => common_name
          }

          request(api_method, parameters, body)
        end
      end

      class Mock
        def insert_ssl_cert(instance_id, common_name)
          if self.data[:ssl_certs].has_key?(instance_id)
            sha1_fingerprint = Fog::Mock.random_hex(40)
            data = {
              'kind' => 'sql#sslCert',
              'instance' => instance_id,
              'sha1Fingerprint' => sha1_fingerprint,
              'commonName' => common_name,
              'certSerialNumber' => Fog::Mock.random_numbers(9),
              'cert' => "-----BEGIN CERTIFICATE-----\nMIIC/zCCAeegAwIBAgIELAk5vzANBgkqhkiG9w0BAQUFADBNMSgwJgYDVQQDEx9H\nb29nbGUgQ2xvdWQgU1FMIENsaWVudCBDQSB0ZXN0MRQwEgYDVQQKEwtHb29nbGUs\nIEluYzELMAkGA1UEBhMCVVMwHhcNMTQwNjA0MDY1MjAwWhcNMjQwNjAxMDY1MjAw\nWjAyMQ0wCwYDVQQDEwR0ZXN0MRQwEgYDVQQKEwtHb29nbGUsIEluYzELMAkGA1UE\nBhMCVVMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9G9ZG19n978EW\n5bQ/TM1Fnb4fd/FRT8XMs2D5C7+dKLEgbeUOvZQt4EsQ6cC+UVhoK7N6DvnXAZ1M\ng+B159Xlqjv8Mh5RihfGjPCdlw2pF7Pu68LyYghvQLhi7yhuNeaN+FBeKvjcW9k0\ni54AM8Ub2a/kxAwMtXm1kGtgc1+qkUlyBxfn1UoKI5Dhvw/InxgI1kS/VUkkk9kv\n0q/oyPrboE/vuSitDq+pHjRFwrIQcS6Pz9DYHhZVyDDkTIh7vLXM0JEQRT1SiA8k\n+4hwXI3WBqPRZRI4H1KmYSSIKvZtci63SbM/rHitXkGipFF1lw0gSqfpM8gG36fl\naITBPI97AgMBAAGjAjAAMA0GCSqGSIb3DQEBBQUAA4IBAQCOvRWYdcaYl/qHgif8\nvD4QEQLiy3+Hn5zSLQEcqP/BymhUw4LSGhu8NJxJ26PvlHzAnWa2/OkTCkgSpM4k\nkebO2vyuU8XY/7FeRO3uNktEAp2Aw1RYJ/IqSDvjpg5/hJTHKADrAkiu2SyCJvoO\nqblzBO7TvLj5BBdvcr1/hfWRuAt5NykOww9AMEAzrfLzrF7f98RntOZzIwwX+UvF\nLXQZwc/b55d97Y249pLRQCBnHdaEtZLQTEQulj1zMx2lkH5CrQWGwDCVFuIyt/rN\nzFJGN09McKrWkBZuwPtkkyb+sBVXZX6cEFgHHA+7D91QRH4lbEjjO8OjQgaA6qWN\n5iGN\n-----END CERTIFICATE-----",
              'createTime' => Time.now.iso8601,
              'expirationTime' => Time.now.iso8601,
            }
            self.data[:ssl_certs][instance_id][sha1_fingerprint] = data
            body = {
              'kind' => 'sql#sslCertsInsert',
              'serverCaCert' => {
                'kind' => 'sql#sslCert',
                'instance' => instance_id,
                'sha1Fingerprint' => Fog::Mock.random_hex(40),
                'commonName' => 'C=US,O=Google\\, Inc,CN=Google Cloud SQL Server CA',
                'certSerialNumber' => '0',
                'cert' => "-----BEGIN CERTIFICATE-----\nMIIDITCCAgmgAwIBAgIBADANBgkqhkiG9w0BAQUFADBIMSMwIQYDVQQDExpHb29n\nbGUgQ2xvdWQgU1FMIFNlcnZlciBDQTEUMBIGA1UEChMLR29vZ2xlLCBJbmMxCzAJ\nBgNVBAYTAlVTMB4XDTE0MDYwNDA1MjkxMVoXDTI0MDYwMTA1MjkxMVowSDEjMCEG\nA1UEAxMaR29vZ2xlIENsb3VkIFNRTCBTZXJ2ZXIgQ0ExFDASBgNVBAoTC0dvb2ds\nZSwgSW5jMQswCQYDVQQGEwJVUzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC\nggEBALlRjq3zccH5ed6NMfCFcTYd9XxYXyvLurxxjDIA6A7/ymVM9qdQC0uckf7C\nsi4uMi2yfK+PHZ0jXC+g0uPx5RTm+nbKl4I++VOh2g6oZHeNdFt4rVJpr+jzGUMf\nr67SymUr70TQOTEVpx2Ud3rBB2szulxWUSXEy2AGA3uNUGe/IgENh7p56s00Sr97\nTRP1S5/JVMalncgNVLH2nNqBQJZTx9t9qvGatoUfmHUU0+M//J5sXLbgdzeEeeot\nHJUyoXjA2sRkH1+F/d6PpFrcr1I8dVmCBEbTAnm7HpKh5Mx2nRYi+t/y9D2Mblwx\n9dBRfr3WIJ1JDxzt3L8CtBGZbvUCAwEAAaMWMBQwEgYDVR0TAQH/BAgwBgEB/wIB\nADANBgkqhkiG9w0BAQUFAAOCAQEAmHuBecPc265sbd26B1HXUAD6FHdzoZLrAZVW\n+1eIK4E669P4y6LkLuoCkLd64/YwA4K2FioksqgHOahbYWJJYPymy4ae+IPXzXcY\nPv3gmBsKk++sHb64D9Cj/k5n8BEiVmmrsUCUiL75nJAzK+El3hvKKWWl76XX/qHP\nk8ZAxIrn8bCiVOaj6NR4+p1OmcZSPNWxz7j/EwQxoABRxgPgt+B/YRseevww7an2\n/rGs0sk7RE0QDjLfZblYGh+xVPBBLuLmf4L5JNJkFEoeGSWrxTzvXnS+2LZeHdM/\nJ9nsiKu5JKPhMUS0vOcTymOkh8tJ6Np8gwg6ca4g6dT3llE6uQ==\n-----END CERTIFICATE-----",
                'createTime' => Time.now.iso8601,
                'expirationTime' => Time.now.iso8601,
              },
              'clientCert' => {
                'certInfo' => data,
                'certPrivateKey' => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAvRvWRtfZ/e/BFuW0P0zNRZ2+H3fxUU/FzLNg+Qu/nSixIG3l\nDr2ULeBLEOnAvlFYaCuzeg751wGdTIPgdefV5ao7/DIeUYoXxozwnZcNqRez7uvC\n8mIIb0C4Yu8objXmjfhQXir43FvZNIueADPFG9mv5MQMDLV5tZBrYHNfqpFJcgcX\n59VKCiOQ4b8PyJ8YCNZEv1VJJJPZL9Kv6Mj626BP77korQ6vqR40RcKyEHEuj8/Q\n2B4WVcgw5EyIe7y1zNCREEU9UogPJPuIcFyN1gaj0WUSOB9SpmEkiCr2bXIut0mz\nP6x4rV5BoqRRdZcNIEqn6TPIBt+n5WiEwTyPewIDAQABAoIBAH89e6+vDL4P05vU\ncrMkufldac9CpNxREIXrLBRmE0drWcK4Lqb8Z/d2MwvuPAHSOendfaVi7jf8nhod\noamzk/gz0qieEEhM4jJ2Im/mcwqTKD5Z45Gy5Hn20hm/UTTWj4p2yZySzV93bW4t\nguIf80AJ+I+0WWczs/C2e4kqF/RrIf4ff7UF/2TPS+sEmkTA74APWIMqjkr0cjTP\nrIJCp8jFn/639dVLeHcw2abduZSV8PkQSNdqPeH2P+GpqkYLREPMAw/jPGZYoVli\npQ57cB1THj/juYFYMS7dlJ3hr0pDo6Vw30L6EcE63dvXzJvhOfPXtFufdfanPiey\nUSICtAECgYEA/qP7ZJ9ohqg4D5v9TM4fVlUpo68/jMaWlPPoLQwNXZ81rTN4yOxm\nUJLhDvQCWYZie1jwn9+UA1bdp4PceSbEWh4iM0h4TcxmhHmos6pxGYb/uw6jGLw4\nqjCqDP69/Jgmkfobs4u/h9xtZEHo6u5rrbDZIu0EezL7ArMrSOYVRsMCgYEAvh5K\n4H5EVMhiHnjvbpToOzGjMpqoBr0XSq63Cx45U5on5Bp8oc/iQPnCzpwcrJb4vwRV\nVYYtD/PWpdjzhTVy6SgVnkTKoo6N/Y9vFAYCf67eb4Yu4L8MonlYU2IY7bA3SChw\nesHlwsVZdlNqieWmOuacA8IbgXW4ftbtZDzBuOkCgYEArA8rn+simtJxxwJVHp+s\nhw5Wa3bQDxRkzVMdz8p0AY3BnD3KYKFz5P/KOOth5xIp20TWmoBdKAB7F2S/BdHP\nHUF9RH+0YoU5xEvcVUJW17PjeobCZ8VO2Ji3Xr6Gq3Y3oa2JKEHGckvcUsFCW/Qs\nKBn2LmZO/9wLxeBA4CovuDcCgYAVGTWEDl807Xv+F7uykPHox8xtrD4jaU6xagxE\nPplsDrqIlOvp5TEdttoIpciE2shGIov5zscncw8KHrZ/vPvApkMn6kh2m81kK0vP\ndA9I7jYfOEvxgyI60a6cqlFL53drGZnJ9cSyxcX03LMBFKxK8xazUBJPXqoX4XA8\n5IU3KQKBgQDCPVBZbZcwcfI+fGRZX8DLE61tscK1uy0ySQPmz/tm3ixDAdQNgGvD\nXjyPvMCEtHx7+ZbykLS7SJZG4924LKyGxF9bw5AYTPyxietOUfoqaS8v3kJ03Ebu\nkVDmZkAiMk5E+oGchYsD613QRFjF4nlmrHfxtRqTPqa/OpNDimdG+w==\n-----END RSA PRIVATE KEY-----",
              }
            }
            status = 200
          else
            body = {
              'error' => {
                'errors' => [
                  {
                    'domain' => 'global',
                    'reason' => 'notAuthorized',
                    'message' => 'The client is not authorized to make this request.',
                  }
                ],
                'code' => 403,
                'message' => 'The client is not authorized to make this request.',
             }
            }
            status = 403
          end

          build_excon_response(body, status)
        end
      end
    end
  end
end
