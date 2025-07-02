class CheckPageResult < ApplicationRecord
  belongs_to :check_page

  before_create :set_revision

  def set_revision
    revision = self.class.where(check_page_id: self.check_page_id).maximum(:revision) || 0
    self.revision = revision + 1
  end

  def clean_body
    text = body
    check_page.site.delete_patterns.strip.split(/[\r\n]+/).each do |pattern|
      text.gsub!(/#{pattern.gsub(/\//, "\\/")}/m, '')
    end
    text.gsub(/[\r\n]+/, "\n")
  end
end
