class ChangeSendMailToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :send_mail, :string
  end
end
