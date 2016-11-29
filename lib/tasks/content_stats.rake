task :app_stats => [:environment] do
  publishing_apps = ContentItem.distinct(:publishing_app) #.take(2)
  result = publishing_apps.flat_map do |publishing_app|
    rendering_apps = ContentItem.where(publishing_app: publishing_app).distinct(:rendering_app)

    rendering_apps.map do |rendering_app|
      count = ContentItem.where(rendering_app: rendering_app, publishing_app: publishing_app).count

      [
        publishing_app,
        rendering_app,
        count
      ] if count > 0
    end.compact
  end

  puts JSON.pretty_generate(result)
end

task :content_stats => [:environment] do
  document_types = ContentItem.distinct(:document_type)
  content_stats = document_types.map do |document_type|
    content_items = ContentItem.where(document_type: document_type)

    {
      name: document_type,
      count: content_items.count,
      schema_names: content_items.distinct(:schema_name),
      publishing_apps: content_items.distinct(:publishing_app),
      rendering_apps: content_items.distinct(:rendering_app),
      examples: content_items.limit(10).order("content_id ASC").map { |item|
        item.as_json.slice("title", "base_path")
      }
    }
  end

  apps = (ContentItem.distinct(:rendering_app) + ContentItem.distinct(:publishing_app)).uniq.compact
  app_stats = apps.map do |app|
    renders = ContentItem.where(rendering_app: app)
    publishes = ContentItem.where(publishing_app: app)

    {
      name: app,
      rendering_count: renders.count,
      publishing_count: publishes.count,
      rendering_examples: renders.limit(10).order("content_id ASC").map { |item|
        item.as_json.slice("title", "base_path")
      },
      publishes_examples: publishes.limit(10).order("content_id ASC").map { |item|
        item.as_json.slice("title", "base_path")
      }
    }
  end

  puts JSON.dump(
    document_types: content_stats,
    apps: app_stats,
    total_document_count: ContentItem.count,
    generated_at: Time.now,
  )
end
