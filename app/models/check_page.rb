class CheckPage < ApplicationRecord
  belongs_to :site
  has_many :check_page_results

  def apply_regexp_pattern(type, body)
    site.send(type).split(/[\r\n]+/).each do |pattern|
      body = body.gsub(/#{pattern.gsub(/\//, "\\/")}/m, '')
    end
    body
  end

  def duplicate_latest_revision?(text)
    latest_revision = check_page_results.order(revision: :desc).first
    if latest_revision.present? && latest_revision.body.gsub(/\s+/, '') == text.gsub(/\s+/, '')
      true
    else
      false
    end
  end
end
