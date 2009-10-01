PathComponent = /([\w\d]|(\._))+/

ActionController::Routing::Routes.draw do |map|
	# Main site links
	map.with_options :controller => 'about' do |about|
    about.about 'about', :action => 'index'
    about.about_director 'about/director', :action => 'director'
    about.history 'about/history', :action => 'history'
	end
	map.news 'news', :controller => 'news'
	map.book 'book', :controller => 'book'
	map.join 'join', :controller => 'join'
	map.resources :concerts, :only => [:index], :collection => {:next => :get, :past => :get, :upcoming => :get}
	map.resources :members, :requirements => {:id => PathComponent}, :member => {:move_up => :put, :move_down => :put}
	map.home 'home', :controller => 'home'
	map.root :home
	
	# Authentication
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.resource :session
	
	# Private for Members with Login
	map.namespace :private do |private|
		private.resource :roster, :only => [:show]
	end
end
