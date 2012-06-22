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
          merge_attributes(connection.query_async_job_result('jobid' => self.id)['queryasyncjobresultresponse'])
        end

        def finished?
          self.job_status != 0
        end
      end # Job
    end # Cloudstack
  end # Compute
end # Fog
