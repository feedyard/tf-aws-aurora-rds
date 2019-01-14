# frozen_string_literal: true

require 'inspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['PLATFORM_ENV'] + '.json'))

describe command('aws rds describe-db-clusters') do
  its('stdout') { should include ("\"DBClusterIdentifier\": \"" + tfvars['name']) }                   # exist
  its('stdout') { should include ("\"Engine\": \"" + tfvars['engine']) }                              # engine
  its('stdout') { should include ("\"EngineVersion\": \"" + + tfvars['engine_version']) }             # engine_version

  its('stdout') { should include ("\"DBSubnetGroup\": \"vpc-ci-tf-aws-platform_db_subnet_group\"") }  # db_subnet_group
  its('stdout') { should include ("\"Status\": \"available\"") }                                      # be available
  its('stdout') { should include ("\"Port\": 5432") }                                                 # port
  its('stdout') { should include ("\"PreferredMaintenanceWindow\": \"sun:05:00-sun:06:00\"") }        # preferred maintenance window
  its('stdout') { should include ("\"PreferredBackupWindow\": \"02:00-03:00\"") }                     # preferred backup window
  its('stdout') { should include ("\"StorageEncrypted\": true") }                                     # storage encryption
  its('stdout') { should include ("\"DeletionProtection\": false") }                                  # deletion protection
end
