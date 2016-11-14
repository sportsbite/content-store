task :content_stats => [:environment] do
  document_types = ContentItem.distinct(:document_type)
  stats = document_types.map do |document_type|
    content_items = ContentItem.where(document_type: document_type)

    {
      name: document_type,
      count: content_items.count,
      schema_names: content_items.distinct(:schema_name),
      publishing_apps: content_items.distinct(:publishing_app),
      rendering_apps: content_items.distinct(:rendering_app),
      examples: content_items.take(10).map(&:base_path),
    }
  end

  puts JSON.pretty_generate(
    document_types: stats,
    generated_at: Time.now,
  )
end
