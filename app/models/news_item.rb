class NewsItem < ActiveRecord::Base
	validates_presence_of :title, :date, :body
	default_scope :order => 'date DESC'
	named_scope :recent, :limit => 10
end
