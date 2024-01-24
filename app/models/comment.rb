class Comment < ApplicationRecord
  include LangchainrbRails::ActiveRecord::Hooks
  #
  # For confirming the result of my temporary workaround,
  # ----------------------------------------
  # include LangchainWrapper
  # ----------------------------------------
  # instead of LangchainrbRails::ActiveRecord::Hooks.
  #
  vectorsearch

  after_save :upsert_to_vectorsearch
end
