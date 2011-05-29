class PageContent < ActiveRecord::Base

  belongs_to :page

  validates :page_id, :presence => true
  validates :key, :presence => true

end
