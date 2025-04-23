# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action do
    I18n.locale = :ja
  end

  # ログイン後、本の一覧ページに移動
  def after_sign_in_path_for(_resource)
    books_path
  end

  # ログアウト後、ログインページに移動
  def after_sign_out_path_for(_resource)
    new_user_session_path
  end
end
