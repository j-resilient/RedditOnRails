class AddTimestampsToSubs < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :subs
  end
end
