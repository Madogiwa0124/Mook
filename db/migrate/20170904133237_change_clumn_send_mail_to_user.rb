class ChangeClumnSendMailToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :send_mail, :boolean, default: false
  end
end
