# This file contains your application, it requires dependencies and necessary
# parts of the application.
require 'rubygems'
require 'ramaze'
require 'sequel'
require 'net/smtp'
require 'net/pop'

Net.instance_eval {remove_const :SMTPSession} if defined?(Net::SMTPSession)

require 'net/pop'
Net::POP.instance_eval {remove_const :Revision} if defined?(Net::POP::Revision)
Net.instance_eval {remove_const :POP} if defined?(Net::POP)
Net.instance_eval {remove_const :POPSession} if defined?(Net::POPSession)
Net.instance_eval {remove_const :POP3Session} if defined?(Net::POP3Session)
Net.instance_eval {remove_const :APOPSession} if defined?(Net::APOPSession)

require 'tlsmail'
require 'time'
require 'yaml'
require 'pp'

#EMAIL_CONFIG=YAML.load_file( '/home/david/Desktop/incidence/incidencepanel/config/email_config.yaml' )

# Make sure that Ramaze knows where you are
Ramaze.options.roots = [__DIR__]

#EMAIL CONFIGURATION
EMAIL_CONFIG=YAML.load_file( "#{Ramaze.options.roots[0]}/config/email_config.yaml" )


# Initialize logger
log_dir = "#{Ramaze.options.roots[0]}/log"
FileUtils.mkdir_p log_dir unless Dir.exist? log_dir
Ramaze::Log.loggers << Ramaze::Logger::RotatingInformer.new(log_dir)

require __DIR__('controller/init')
require __DIR__('helper/stats')
require __DIR__('snippets/init')
require __DIR__('../incidencedb/model/init')

# Load all controllers
Dir.glob(__DIR__('controller') + '/**/*.rb').each do |f|
  require f
end
