
require 'logger'
require 'sequel'

class Object
  unless defined?(__DIR__)
    # This is similar to +__FILE__+ and +__LINE__+, and returns a String
    # representing the directory of the current file is.
    # Unlike +__FILE__+ the path returned is absolute.
    #
    # This method is convenience for the
    #  File.expand_path(File.dirname(__FILE__))
    # idiom.
    def __DIR__(*args)
      filename = caller[0][/^(.*):/, 1]
      dir = File.expand_path(File.dirname(filename))
      ::File.expand_path(::File.join(dir, *args.map{|a| a.to_s}))
    end
  end
end

DB = Sequel.connect(adapter: 'postgres',
                    host: 'localhost',
                    user: 'incidence',
                    password: 'incidence',
                    database: 'incidence',
                    test: true,
                    encoding: 'utf8',
                    loggers: [Logger.new(File.open "/tmp/rmxdb-#{File.basename $0}.log", 'w')])

DB.sql_log_level = :debug

Sequel::Model.plugin :update_primary_key
Sequel::Model.plugin :validation_helpers
Sequel.extension :migration
Sequel.extension :pagination
Sequel::Migrator.run(DB, __DIR__('../migrations'))

require_relative 'incidence'
require_relative 'motive'
require_relative 'connection'
require_relative 'group'

# create default content if it doesn't exists
unless Motive[id: 1]
  m = Motive.new
  m.id = 1
  m.name = 'Acuse Recibo'
  m.save
end

unless Motive[id: 2]
  m = Motive.new
  m.id = 2
  m.name = 'Pendiente'
  m.save
end

unless Motive[id: 3]
  m = Motive.new
  m.id = 3
  m.name = 'Solucion'
  m.save
end
