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
    report.created_at = '2026/1/2'.in_time_zone
    assert_equal '2026/1/2'.to_date, report.created_on
  end

  test '#save_mentions' do
    alice = users(:alice)
    bob = users(:bob)
    alice_report = alice.reports.create!(title: '日報', content: 'これからよろしくお願いします。')
    bob_report = bob.reports.create!(title: '日報', content: "http://localhost:3000/reports/#{alice_report.id}が参考になりました")
    assert_equal [alice_report], bob_report.mentioning_reports

    bob_report.update(title: '更新', content: '更新しました。')
    assert_equal [], bob_report.reload.mentioning_reports
  end
end
