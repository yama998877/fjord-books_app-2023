# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]
  before_action :set_comment, only: %i[destroy]
  before_action :user_confirmation, only: %i[destroy]

  # POST /comments
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    elsif @comment.commentable_type == 'Report'
      @report = @commentable
      render 'reports/show', status: :unprocessable_entity
    elsif @comment.commentable_type == 'Book'
      @book = @commentable
      render 'books/show', status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  # 送られてきたハッシュにどちらのidがあるのか判定
  def set_commentable
    if params[:book_id]
      @commentable = Book.find(params[:book_id])
    elsif params[:report_id]
      @commentable = Report.find(params[:report_id])
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def user_confirmation
    redirect_to polymorphic_path(@commentable), alert: t('errors.messages.not_creator', model: Comment.model_name.human) unless @comment.user == current_user
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
