class AddLoginStatisticsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_sign_in_date, :datetime
    add_column :users, :last_activity_date, :datetime
    add_column :users, :sign_in_counter, :int
    add_column :users, :incorrect_sign_in_counter, :int
  end
end
