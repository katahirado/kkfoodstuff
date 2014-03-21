class Recipe < ActiveRecord::Base
  has_one :search_content

  after_save :update_search_content
  after_destroy :remove_search_content

  private

  def update_search_content
    if title_changed? or content_changed?
      child = SearchContent.find_or_initialize_by(recipe_id: self.id)
      child.origin_title = self.title
      child.origin_content = self.content
      child.save
    end
  end

  def remove_search_content
    self.search_content.try(:destroy)
  end
end
