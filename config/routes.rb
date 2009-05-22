ActionController::Routing::Routes.draw do |map|
	map.history 'history', :controller => 'history'
	map.news 'news', :controller => 'news'
	map.book 'book', :controller => 'book'
	map.join 'join', :controller => 'join'
	map.resources :players, :only => [:index]
	map.resources :concerts, :only => [:index], :collection => {:next => :get, :past => :get, :upcoming => :get}
	map.home 'home', :controller => 'home'
	map.root :home
end
