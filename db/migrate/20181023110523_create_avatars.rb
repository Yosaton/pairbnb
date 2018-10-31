class CreateAvatars < ActiveRecord::Migration[5.2]
  def change
    create_table :avatars do |t|
    	t.string :avatar_image
    	t.integer :user_id

		t.timestamps
    end
  end
end
