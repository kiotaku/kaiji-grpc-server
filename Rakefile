require 'active_record'
require 'mysql2'
require 'yaml'
require 'zlib'

desc 'Migrate database'
task migrate: :environment do
  ActiveRecord::Migrator.migrate './db/migration', nil
end

desc 'Create database'
task :create do
  dbconfig = YAML.load_file './config/database.yml'

  client = Mysql2::Client.new(dbconfig['db']['development'].merge(database: nil))
  client.query("CREATE DATABASE kaiji")
end

task :environment do
  dbconfig = YAML.load_file './config/database.yml'
  ActiveRecord::Base.establish_connection dbconfig['db']['development']
  ActiveRecord::Base.logger = Logger.new './log/database.log'
end
