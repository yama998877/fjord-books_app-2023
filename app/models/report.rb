# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning_relationships, class_name: 'Mention', foreign_key: 'mentioning_id', dependent: :destroy, inverse_of: :mentioning
  has_many :mentioning_reports, through: :mentioning_relationships, source: :mentioned

  has_many :mentioned_relationships, class_name: 'Mention', foreign_key: 'mentioned_id', dependent: :destroy, inverse_of: :mentioned
  has_many :mentioned_reports, through: :mentioned_relationships, source: :mentioning

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention_url_check(str)
    mentioning_reports.destroy_all if mentioning_reports.exists?
    check_url = 'http://localhost:3000/reports/'
    report_url_check = URI.extract(str, ['http']).uniq.select { |url| url.start_with?(check_url) }

    repo_ids = report_url_check.map { |url| url.gsub(check_url, '').to_i }
    repo_ids.delete(id)

    existing_ids = Report.where(id: repo_ids).pluck(:id)
    existing_ids = existing_ids.map { |id| { mentioned_id: id } }
    mentioning_relationships.build(existing_ids)
  end
end
