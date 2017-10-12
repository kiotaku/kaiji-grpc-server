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

  ActiveRecord::Base.establish_connection(dbconfig['db'][mode].symbolize_keys.merge(:database => "mysql"))
  ActiveRecord::Base.connection.drop_database dbconfig['db'][mode].symbolize_keys[:database] rescue nil
  ActiveRecord::Base.connection.create_database dbconfig['db'][mode].symbolize_keys[:database]
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
