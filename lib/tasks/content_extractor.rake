namespace :content_extractor do
  desc "Extracts content out of the html and stores it"
  task store_content: :environment do

    puts "Querying the db.."
    items = ContentItem.all.select {|i| i.details.any? && i.details.has_key?('body')} # should rewrite this as a proper sql query and ignore items already parsed

    puts "Total items: #{items.count}"
    count = 0

    items.each do |i|

      count += 1

      next if i['details']['body'].nil? # can be nil, this line can be removed with an appropriate db query

      begin
        nokogiri_el = Nokogiri::HTML(i['details']['body'][0]['content'])
      rescue
        binding.pry # to debug unexpected crashes
      end

      # extract text
      nokogiri_el = nokogiri_el.search('//text()').map(&:text)
      # remove empty lines
      nokogiri_el = nokogiri_el.select {|i| i != "\n\n" && i != "\n"}
      # join back into a string
      nokogiri_el = nokogiri_el.join(" ")

      unless nokogiri_el.empty? # to avoid storing empty content
        i['parsed'] = true # updating this key for future db queries
        i['content'] = nokogiri_el
        i.save
      end

      if count % 100 == 0
        puts "Processed #{count} items of #{items.count}"
      end
    end
  end
end
