require "hashdiff"
require "pp"

class CompareLink
  attr_reader :new, :content_item

  def initialize(content_item)
    @content_item = content_item
    @old = content_item.linked_items
    @new = content_item.expanded_links
  end

  def compare
    puts "DIFF #{content_item.content_id} #{'*' * 20}"
    pp HashDiff.diff(sort(old), sort(new))
  end

private

  def old
    @old.each_with_object({}) do |(link_type, linked_items), items|
      items[link_type] = linked_items.map do |i|
        LinkedItemPresenter.new(i, api_url_method).present
      end
    end
  end

  def api_url_method
    lambda { |a| Plek.current.website_root + "/api/content/" + a }
  end

  def sort(links)
    links.each_with_object({}) do |(k, v), h|
      h[k] = v.map do |value|
        Hash[value.except(*known_exceptions).sort]
      end
    end
  end

  def known_exceptions
    %w(
      document_type
      expanded_links
      links
      public_updated_at
      schema_name
    )
  end
end
