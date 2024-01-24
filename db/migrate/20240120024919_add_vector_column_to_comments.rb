class AddVectorColumnToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimension
  end
end
