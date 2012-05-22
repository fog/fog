module Fog
  module Compute
    class Cloudstack
      class Job < Fog::Model

        identity  :id,              :aliases => 'jobid'
        attribute :user_id,         :aliases => 'userid'
        attribute :account_id,      :aliases => 'accountid'
        attribute :cmd
        attribute :job_status,      :aliases => 'jobstatus'
        attribute :job_result_type, :aliases => 'jobresulttype'
        attribute :job_result_code, :aliases => 'jobresultcode'
        attribute :job_proc_status, :aliases => 'jobprocstatus'

        attribute :created_at,      :aliases => 'created', :type => :time
        attribute :job_result,      :aliases => 'jobresult'

        def reload
          requires :id
          merge_attributes(connection.query_async_job_result('jobid' => self.id)['queryasyncjobresultresponse'])
        end
      end # Job
    end # Cloudstack
  end # Compute
end # Fog
