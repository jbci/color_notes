class CreateJoinTableBoardColor < ActiveRecord::Migration
  def change
    create_join_table :boards, :colors do |t|
      # t.index [:board_id, :color_id]
      # t.index [:color_id, :board_id]
    end
  end
end
