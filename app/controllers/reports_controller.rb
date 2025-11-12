# frozen_string_literal: true

require 'uri'

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    str = @report.content
    mention_url_check(@report, str)
    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    str = report_params[:content]
    mention_url_check(@report, str)
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      @report.mentioning_report_ids = mention_url_check(@report, str)
    end
    redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def mention_url_check(report, str)
    check_url = 'http://localhost:3000/reports/'
    report_url_check = URI.extract(str, ['http']).uniq.select { |url| url.start_with?(check_url) }
    repo_ids = report_url_check.map { |url| url.gsub(check_url, '').to_i }
    existing_ids = repo_ids.select { |repo_id| Report.find_by(id: repo_id) }

    return existing_ids if Report.exists?(report.id)

    existing_ids = existing_ids.map { |id| { mentioned_id: id } }
    report.mentioning_relationships.build(existing_ids)
  end
end
