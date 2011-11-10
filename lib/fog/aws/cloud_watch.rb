require File.expand_path(File.join(File.dirname(__FILE__), '..', 'aws'))

module Fog
  module AWS
    class CloudWatch < Fog::Service


      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent

      request_path 'fog/aws/requests/cloud_watch'

      request :list_metrics
      request :get_metric_statistics
      request :put_metric_data
      request :describe_alarms
      request :put_metric_alarm
      request :delete_alarms
      request :describe_alarm_history
      request :enable_alarm_actions
      request :disable_alarm_actions
      request :describe_alarms_for_metric
      request :set_alarm_state

      model_path 'fog/aws/models/cloud_watch'
      model       :metric
      collection  :metrics
      model       :metric_statistic
      collection  :metric_statistics
      model       :alarm_datum
      collection  :alarm_data
      model       :alarm_history
      collection  :alarm_histories
      model       :alarm
      collection  :alarms

      class Mock

        def initialize(options={})
        end

      end

      class Real

        # Initialize connection to Cloudwatch
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   elb = CloudWatch.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use, in ['eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'ap-southeast-1', 'ap-northeast-1']
        #
        # ==== Returns
        # * CloudWatch object with connection to AWS.
        def initialize(options={})
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @hmac = Fog::HMAC.new('sha256', @aws_secret_access_key)

          @connection_options = options[:connection_options] || {}
          options[:region] ||= 'us-east-1'
          @host = options[:host] || case options[:region]
          when 'ap-northeast-1'
            'monitoring.ap-northeast-1.amazonaws.com'
          when 'ap-southeast-1'
            'monitoring.ap-southeast-1.amazonaws.com'
          when 'eu-west-1'
            'monitoring.eu-west-1.amazonaws.com'
          when 'us-east-1'
            'monitoring.us-east-1.amazonaws.com'
          when 'us-west-1'
            'monitoring.us-west-1.amazonaws.com'
          when 'us-west-2'
            'monitoring.us-west-2.amazonaws.com'
          else
            raise ArgumentError, "Unknown region: #{options[:region].inspect}"
          end
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        private

        def request(params)
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body = AWS.signed_params(
            params,
            {
              :aws_access_key_id  => @aws_access_key_id,
              :hmac               => @hmac,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => '2010-08-01'
            }
          )

          response = @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => { 'Content-Type' => 'application/x-www-form-urlencoded' },
            :idempotent => idempotent,
            :host       => @host,
            :method     => 'POST',
            :parser     => parser
          })
        end

      end
    end
  end
end
