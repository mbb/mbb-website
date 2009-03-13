ActionController::Routing::Routes.draw do |map|
	map.news 'news', :controller => 'news', :action => :index
	map.book 'book', :controller => 'book', :action => :index
	map.join 'join', :controller => 'join', :action => :index
	map.resources :players, :only => [:index]
	map.resources :concerts, :only => [:index], :collection => {:next => :get}
	map.home 'home', :controller => 'home'
	map.root :home
end
