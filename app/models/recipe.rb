class Recipe < ActiveRecord::Base
  has_one :search_content

  after_save :update_search_content
  after_destroy :remove_search_content

  private

  def update_search_content
    search_content ||= build_search_content
    search_content.title = self.title if search_content.title.blank? or title_changed?
    search_content.content = self.content if search_content.content.blank? or content_changed?
    search_content.save
  end

  def remove_search_content
    self.search_content.try(:destroy)
  end
end
