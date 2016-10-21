require 'active_record'
require 'yaml'
require 'zlib'

desc 'Migrate database'
task migrate: :environment do
  ActiveRecord::Migrator.migrate './db/migration', nil
end

task :environment do
  dbconfig = YAML.load_file './config/database.yml'
  ActiveRecord::Base.establish_connection dbconfig['db']['development']
  ActiveRecord::Base.logger = Logger.new './log/database.log'
end
