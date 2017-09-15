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
  mode = 'development'
  if ENV['kaiji_exec'] == 'production'
    mode = 'production'
  end

  client = Mysql2::Client.new(dbconfig['db'][mode].merge(database: nil))
  client.query("CREATE DATABASE kaiji")
end

task :environment do
  dbconfig = YAML.load_file './config/database.yml'
  mode = 'development'
  if ENV['kaiji_exec'] == 'production'
    mode = 'production'
  end

  ActiveRecord::Base.establish_connection dbconfig['db'][mode]
  ActiveRecord::Base.logger = Logger.new './log/database.log'
end
