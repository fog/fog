module Fog
  module Compute
    class IBM
      class Real

        # Returns license agreement of image specified by id
        #
        # ==== Parameters
        # 'image_id'<~String>: id of desired image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'text'<~String>: text of license
        #     * 'id'<~String>: id of image
        #     * 'attachments'<~Array>: Additional agreements attached to image
        #       * 'label'<~String>: description of attachment
        #       * 'url'<~String>: url to retrieve attachment
        #       * 'type'<~Integer>: type of attachment
        def get_image_agreement(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}/agreement"
          )
        end

      end

      class Mock

        # TODO: Fix this so they work.
        def get_image_agreement(image_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {"text"=>
              "test, operating system is SUSE Linux Enterprise Server/11 SP1 - English\n\nYour access to and use of the Service, including all selected options, are governed by the terms of the Agreement signed between your Enterprise and IBM.  Each Service is also governed by one or more Attachments (including, for example, Image Terms Attachments).  Applicable Attachments are part of the Agreement between you and IBM and include Attachments for Services you acquire after the Agreement was signed.  The Agreement also references applicable IBM and third party end user license agreements that govern the use of IBM software and operating system software provided as part of an Image.\n\nYou are responsible for complying with the terms of the Agreement (including applicable Attachments) and applicable license agreements. You may review the terms for the Service by 1) obtaining information regarding the Agreement from your Account Administrator and 2) accessing the Asset Catalog to review specific Image Terms and end user license agreements for IBM and third party software provided as part of an Image.  ",
             "id"=>"20020159",
             "attachments"=>
              [{"label"=>"Service Description for Developement & Test Service",
                "url"=>
                 "https://www-147.ibm.com/cloud/enterprise/static/internal_user_agreement.pdf",
                "type"=>0},
               {"label"=>"Smart Business on the IBM Public Cloud Agreement",
                "url"=>
                 "https://www-147.ibm.com/cloud/enterprise/static/internal_user_agreement.pdf",
                "type"=>1},
               {"label"=>
                 "End User License for SUSE 10.2 Linux Enterprise Server software",
                "url"=>
                 "https://www.novell.com/licensing/eula/sles_10/sles_10_english.pdf",
                "type"=>2},
               {"label"=>
                 "End User License for SUSE 11.0 Linux Enterprise Server software",
                "url"=>"https://www.novell.com/licensing/eula/sles_11/sles_11_en.pdf",
                "type"=>2},
               {"label"=>"End User License for RedHat Linux RHEL software",
                "url"=>"https://www.redhat.com/licenses/",
                "type"=>2}]}
          response
        end

      end
    end
  end
end
