# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    click_link '日報'
  end

  test 'visiting the index' do
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'check created_at' do
    click_link 'この日報を表示', match: :first
    assert_text '2026/01/02'
  end

  test 'check create report' do
    click_link '日報の新規作成'
    fill_in 'タイトル', with: 'システムテストを行いました'
    fill_in '内容', with: '日報の新規作成のテストをしました'
    click_button '登録する'
    assert_text '日報が作成されました。'

    click_link '日報の一覧に戻る'
    assert_text 'システムテストを行いました'
    assert_text '日報の新規作成のテストをしました'
  end

  test 'check update Report' do
    click_link 'この日報を表示', match: :first
    click_link 'この日報を編集'
    fill_in 'タイトル', with: 'タイトル更新しました'
    fill_in '内容', with: '内容を更新しました'
    click_button '更新する'
    assert_text '日報が更新されました。'

    click_link '日報の一覧に戻る'
    assert_text 'タイトル更新しました'
    assert_text '内容を更新しました'
  end

  test 'should destroy Report' do
    click_link 'この日報を表示', match: :first
    click_button 'この日報を削除'
    assert_text '日報が削除されました。'
    assert_no_text '試作日報'
  end
end
