class ChangeBodyToTextInReports < ActiveRecord::Migration[7.0]
  def change
    change_column :reports, :body, :text
  end
end
