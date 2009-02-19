ActionController::Routing::Routes.draw do |map|
	map.resources :concerts, :only => [], :collection => {:next => :get}
	map.home 'home', :controller => 'home'
	map.root :home
end
