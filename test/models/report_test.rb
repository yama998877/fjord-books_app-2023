# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?(target_user)' do
    report = reports(:alice_report)
    user = users(:alice)

    assert_equal true, report.editable?(user)
  end
  test '#created_on' do
    report = reports(:alice_report)
    assert_equal report.created_at.to_date, report.created_on
  end
  test '#save_mentions' do
    user1 = users(:alice)
    user2 = users(:bob)
    report1 = user1.reports.create!(title: '日報', content: 'これからよろしくお願いします。')
    report2 = user2.reports.create!(title: '日報', content: "http://localhost:3000/reports/#{report1.id}が参考になりました")
    assert_equal [report1], report2.mentioning_reports

    report2.update(title: '更新', content: '更新しました。')
    assert_equal [], report2.reload.mentioning_reports
  end
end
