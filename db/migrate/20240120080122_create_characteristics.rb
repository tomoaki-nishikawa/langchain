class CreateCharacteristics < ActiveRecord::Migration[7.1]
  def change
    create_table :characteristics do |t|
      t.string :text

      t.timestamps
    end
  end
end
