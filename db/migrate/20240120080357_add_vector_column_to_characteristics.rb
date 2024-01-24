class AddVectorColumnToCharacteristics < ActiveRecord::Migration[7.1]
  def change
    add_column :characteristics, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimension
  end
end
