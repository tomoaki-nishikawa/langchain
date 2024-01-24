module LangchainWrapper
  extend ActiveSupport::Concern
  include LangchainrbRails::ActiveRecord::Hooks

  DEFAULT_SIMIRALITY_SEARCH_COUNT = 1
  DEFAULT_ASK_RESULT_COUNT        = 4

  class_methods do
    def langchainrb_provider
      @langchainrb_provider ||= LangchainrbRails.config.vectorsearch.dup
    end

    def vectorsearch
      return unless langchainrb_provider.is_a?(Langchain::Vectorsearch::Pgvector)

      # pg_vector specific configuration
      has_neighbors(:embedding)
      langchainrb_provider.model = self
    end

    def similarity_search(query, k: DEFAULT_SIMIRALITY_SEARCH_COUNT)
      records = langchainrb_provider.similarity_search(query, k:)

      return records if langchainrb_provider.is_a?(Langchain::Vectorsearch::Pgvector)

      # We use "__id" when Weaviate is the provider
      ids = records.map { |record| record.try("id") || record["__id"] }
      where(id: ids)
    end

    def ask(question, k: DEFAULT_ASK_RESULT_COUNT, &block)
      langchainrb_provider.ask(question, k:, &block).completion
    end
  end

  def upsert_to_vectorsearch
    provider  = self.class.langchainrb_provider
    params    = { texts: [as_vector], ids: [id] }
    if previously_new_record?
      provider.add_texts(**params)
    else
      provider.update_texts(**params)
    end
  end
end
