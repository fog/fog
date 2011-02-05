module Fog
  module AWS
    class SQS
      class Real

        require 'fog/aws/parsers/sqs/list_queues'
        require 'fog/aws/parsers/sqs/delete_queue'

        def delete_queue(name)
          url = extract_url_with_name_from_list(name)
          path = extract_path_from_url(url)

          request({
            'Action' => 'DeleteQueue',
            :parser  => Fog::Parsers::AWS::SQS::DeleteQueue.new,
            :path    => path
          })
        end

        protected

        def extract_url_with_name_from_list(name)
          list_queues.body['QueueUrls'].detect { |url| url.match(/\/#{name}$/) }
        end

        def extract_path_from_url(url)
          url.gsub(/.*\.com/, '')
        end
      end

      class Mock

        def delete_queue(name)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
