class PageContent < ActiveRecord::Base

  belongs_to :page

  attr_accessible :content

  validates :page_id, :presence => true
  validates :key, :presence => true

end
