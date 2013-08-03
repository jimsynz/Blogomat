class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.datetime :published_at
      t.text :body

      t.timestamps
    end
  end
end
