class ChangeSendMailOptionToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :send_mail, nil
  end
end
