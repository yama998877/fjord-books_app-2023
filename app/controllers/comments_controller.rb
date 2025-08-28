# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy]
  before_action :check_user_confirmation, only: %i[destroy]

  # POST /comments
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      render_commentable_show
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!

    redirect_to polymorphic_path(@commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def check_user_confirmation
    redirect_to polymorphic_path(@commentable), alert: t('errors.messages.not_creator', model: Comment.model_name.human) unless @comment.user == current_user
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
