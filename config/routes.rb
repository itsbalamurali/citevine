Citivine::Application.routes.draw do
	  get "index/index"
	  root :to => "index#index"
	  #match for for webrick subdirectory
	  match '/citivine' => 'index#index'
	  #Search
	  match '/item(/:item)' => 'index#index', :as => :index_item
	  #get feeds (by type, subtype (channels), id (channels))
	  match 'list/:type(/:subtype)(/id/:id)(/page/:page)(/load/:load)' => 'feeds#list', :as => :list
	  #Search
	  match 'search(/:request)(/:type)(/:page)' => 'feeds#search', :as => :search
	  #list feeds by tag id
	  match 'tag/:tag(/page/:page)(/count/:size)' => 'tags#tag', :as => :tag
	  #fetch metas by post
	  match 'post(/cat/:cat)(/:type)/:post' => 'feeds#metas', :as => :metas
	  #fetch more metas by post
	  match 'post(/cat/:cat)(/:type)/:post(/page/:page)' => 'feeds#metas_more', :as => :metas_more
	  #uniq user
	  match 'user/:user(/:username)(/page/:page)(/load/:load)' => 'users#user', :as => :user
	  #uniq vine (video)
	  match 'feeds/post' => 'feeds#post', :as => :post
	  #test route
	  match 'test/test' => 'feeds#test', :as => :test
	  #Set number of items per page
	  match 'count/:size' => 'index#change_session_size', :as => :change_session_size
	  #Set autoload
	  match 'autoload/:autoload' => 'index#change_session_autoload', :as => :change_session_autoload
	  #Set autoplay
	  match 'autoplay/:autoplay' => 'index#change_session_autoplay', :as => :change_session_autoplay
	  #Set volume
	  match 'volume/:volume' => 'index#change_session_volume', :as => :change_session_volume
	  #About page
	  match 'whatsnew' => 'index#whatsnew', :as => :whatsnew
	  #About page
	  match 'about' => 'index#about', :as => :about
	  #Contact page
	  match 'contact' => 'index#contact', :as => :contact, :via => :get
	  match 'contact' => 'index#contact_send', :as => :contact_send, :via => :post
end
