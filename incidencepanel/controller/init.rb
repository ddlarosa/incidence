# Define a subclass of Ramaze::Controller holding your defaults for all controllers. Note 
# that these changes can be overwritten in sub controllers by simply calling the method 
# but with a different value.

class Controller < Ramaze::Controller
  layout :default
  helper :xhtml
  engine :etanni

  # user needs to be logged in unless it's going to login page
  #before_all do
  #  if action.method.to_sym != :login and (!logged_in? or !user)
  #    flash[:error] = 'You need to be logged in to view that page'
  #    call UsersController.r(:login)
  #  end
  #end

end

# Here you can require all your other controllers. Note that if you have multiple
# controllers you might want to do something like the following:
#
#  Dir.glob('controller/*.rb').each do |controller|
#    require(controller)
#  end
#
require __DIR__('main')
