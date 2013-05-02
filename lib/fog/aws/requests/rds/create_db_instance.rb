module Fog
  module AWS
    class RDS
      class Real

        require 'fog/aws/parsers/rds/create_db_instance'

        # Create a db instance
        # 
        # @param DBInstanceIdentifier [String] name of the db instance to modify
        # @param AllocatedStorage [Integer] Storage space, in GB
        # @param AutoMinorVersionUpgrade [Boolean] Indicates that minor version upgrades will be applied automatically to the DB Instance during the maintenance window
        # @param AvailabilityZone [String] The availability zone to create the instance in
        # @param BackupRetentionPeriod [Integer] 0-8 The number of days to retain automated backups.
        # @param DBInstanceClass [String] The new compute and memory capacity of the DB Instance
        # @param DBName [String] The name of the database to create when the DB Instance is created
        # @param DBParameterGroupName [String] The name of the DB Parameter Group to apply to this DB Instance
        # @param DBSecurityGroups [Array] A list of DB Security Groups to authorize on this DB Instance
        # @param Engine [String] The name of the database engine to be used for this instance.
        # @param EngineVersion [String] The version number of the database engine to use.
        # @param MasterUsername [String] The db master user
        # @param MasterUserPassword [String] The new password for the DB Instance master user
        # @param MultiAZ [Boolean] Specifies if the DB Instance is a Multi-AZ deployment
        # @param Port [Integer] The port number on which the database accepts connections.
        # @param PreferredBackupWindow [String] The daily time range during which automated backups are created if automated backups are enabled
        # @param PreferredMaintenanceWindow [String] The weekly time range (in UTC) during which system maintenance can occur, which may result in an outage
        # @param DBSubnetGroupName [String] The name, if any, of the VPC subnet for this RDS instance
        # 
        # @return [Excon::Response]:
        #   * body [Hash]:
        # 
        # @see http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
        def create_db_instance(db_name, options={})

          if security_groups = options.delete('DBSecurityGroups')
            options.merge!(Fog::AWS.indexed_param('DBSecurityGroups.member.%d', [*security_groups]))
          end

          request({
            'Action'  => 'CreateDBInstance',
            'DBInstanceIdentifier' => db_name,
            :parser   => Fog::Parsers::AWS::RDS::CreateDBInstance.new,
          }.merge(options))
        end

      end

      class Mock

        def create_db_instance(db_name, options={})
          response = Excon::Response.new
          if self.data[:servers] and self.data[:servers][db_name]
            # I don't know how to raise an exception that contains the excon data
            #response.status = 400
            #response.body = {
            #  'Code' => 'DBInstanceAlreadyExists',
            #  'Message' => "DB Instance already exists"
            #}
            #return response
            raise Fog::AWS::RDS::IdentifierTaken.new("DBInstanceAlreadyExists #{response.body.to_s}")
          end

          # These are the required parameters according to the API
          required_params = %w{AllocatedStorage DBInstanceClass Engine MasterUserPassword MasterUsername }
          required_params.each do |key|
            unless options.has_key?(key) and options[key] and !options[key].to_s.empty?
              #response.status = 400
              #response.body = {
              #  'Code' => 'MissingParameter',
              #  'Message' => "The request must contain the parameter #{key}"
              #}
              #return response
              raise Fog::AWS::RDS::NotFound.new("The request must contain the parameter #{key}")
            end
          end

          data =
              {
                 "DBInstanceIdentifier"=> db_name,
                 "DBName" => options["DBName"],
                 "InstanceCreateTime" => nil,
                 "AutoMinorVersionUpgrade"=>true,
                 "Endpoint"=>{},
                 "ReadReplicaDBInstanceIdentifiers"=>[],
                 "PreferredMaintenanceWindow"=>"mon:04:30-mon:05:00",
                 "Engine"=> options["Engine"],
                 "EngineVersion"=> options["EngineVersion"] || "5.5.12",
                 "PendingModifiedValues"=>{"MasterUserPassword"=>"****"}, # This clears when is available
                 "MultiAZ"=> !!options['MultiAZ'],
                 "MasterUsername"=> options["MasterUsername"],
                 "DBInstanceClass"=> options["DBInstanceClass"],
                 "DBInstanceStatus"=>"creating",
                 "BackupRetentionPeriod"=> options["BackupRetentionPeriod"] || 1,
                 "AllocatedStorage"=> options["AllocatedStorage"],
                 "DBParameterGroups"=> # I think groups should be in the self.data method
                          [{"DBParameterGroupName"=>"default.mysql5.5",
                            "ParameterApplyStatus"=>"in-sync"}],
                 "DBSecurityGroups"=>
                          [{"Status"=>"active", 
                            "DBSecurityGroupName"=>"default"}],
                 "LicenseModel"=>"general-public-license",
                 "PreferredBackupWindow"=>"08:00-08:30",
#                 "ReadReplicaSourceDBInstanceIdentifier" => nil,
#                 "LatestRestorableTime" => nil,
                 "AvailabilityZone" => options["AvailabilityZone"],
                 "DBSubnetGroupName" => options["DBSubnetGroupName"]
             }


          self.data[:servers][db_name] = data
          response.body = {
            "ResponseMetadata"=>{ "RequestId"=> Fog::AWS::Mock.request_id },
            "CreateDBInstanceResult"=> {"DBInstance"=> data}
          }
          response.status = 200
          # This values aren't showed at creating time but at available time
          self.data[:servers][db_name]["InstanceCreateTime"] = Time.now
          self.data[:tags] ||= {}
          self.data[:tags][db_name] = {}
          response
        end

      end
    end
  end
end
