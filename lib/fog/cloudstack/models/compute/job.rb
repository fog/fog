module Fog
  module Compute
    class Cloudstack
      class Job < Fog::Model
        identity  :id,              :aliases => 'jobid'
        attribute :user_id,         :aliases => 'userid'
        attribute :account_id,      :aliases => 'accountid'
        attribute :cmd
        attribute :job_status,      :aliases => 'jobstatus',     :type => :integer
        attribute :job_result_type, :aliases => 'jobresulttype'
        attribute :job_result_code, :aliases => 'jobresultcode', :type => :integer
        attribute :job_proc_status, :aliases => 'jobprocstatus', :type => :integer

        attribute :created_at,      :aliases => 'created',       :type => :time
        attribute :job_result,      :aliases => 'jobresult'

        def reload
          requires :id
          merge_attributes(service.query_async_job_result('jobid' => self.id)['queryasyncjobresultresponse'])
        end

        def ready?
          self.job_status != 0
        end

        def successful?
          self.job_result_code == 0
        end

        # so dirty
        def result
          if successful? && model = Fog::Compute::Cloudstack.constants.find{|c| c.to_s.downcase == self.job_result.keys.first.to_s}.to_s
            collection = model.gsub(/.[A-Z]/){|w| "#{w[0,1]}_#{w[1,1].downcase}"}.downcase + "s" # cheap underscorize, assume simple pluralization
            service.send(collection).new(self.job_result.values.first)
          else self.job_result
          end
        end

        def save
          raise Fog::Errors::Error.new('Creating a job is not supported')
        end

        def destroy
          raise Fog::Errors::Error.new('Destroying a job is not supported')
        end


      end # Job
    end # Cloudstack
  end # Compute
end # Fog
