require 'active_record'
require 'yaml'

desc 'Migrate database'
task :migrate => :environment do
  ActiveRecord::Migrator.migrate 'db/migrate', ENV['VERSION'] ? ENV['VERSION'] : nil
end

task :environment do
  dbconfig = YAML.load_file './config/database.yml'
  ActiveRecord::Base.establish_connection dbconfig[ENV['ENV'] ? ENV['ENV'] : 'production']
  ActiveRecord::Base.logger = Logger.new 'db/database.log'
end
