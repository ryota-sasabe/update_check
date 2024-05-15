class CheckPageResult < ApplicationRecord
  belongs_to :check_page

  before_create :set_revision

  def set_revision
    revision = self.class.where(check_page_id: self.check_page_id).maximum(:revision) || 0
    self.revision = revision + 1
  end
end
