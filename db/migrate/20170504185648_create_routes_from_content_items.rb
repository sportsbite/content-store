class CreateRoutesFromContentItems < Mongoid::Migration
  def self.up
    command = <<~MONGOJS
    db.content_items.find().forEach(function(c) {
      c.redirects.forEach(function(r) {
        db.routes.insert({
          incoming_path: r.path,
          base_path: c._id,
          route_type: r.type,
          handler: 'redirect',
          redirect_to: r.destination,
          redirect_type: r.redirect_type || 'permanent',
          segments_mode: r.segments_mode
        });
      });
      c.routes.forEach(function(r) {
        route = {
          incoming_path: r.path,
          route_type: r.type,
          base_path: c._id
        };
        if (c.schema_name == 'gone' || c.format == 'gone') {
            route.handler = 'gone'
        } else {
          route.handler = 'backend';
          route.backend_id = c.rendering_app;
        }
        db.routes.insert(route);
      });
    });
    MONGOJS

    puts 'Creating indexes'
    Mongoid::Tasks::Database.create_indexes([Route, Backend])
    puts 'Creating routes'
    Mongoid.default_client.database.command({ eval: command, nolock: true })
    puts 'Creating backends'
    Route.distinct(:backend_id).each do |backend_id| 
      next unless backend_id.present?
      backend = Backend.new(backend_id: backend_id, backend_url: Plek.find(backend_id) + '/')
      unless backend.save
        puts backend_id, backend.errors.full_messages.to_sentence
      end
    end
  end

  def do_never
    # result = db.routes.group({key: {backend_id: 1}, reduce: function(cur, result) { result.count += 1 }, initial: {count: 0}, cond: {handler: "backend"}}).sort(function(a, b) { if (a.backend_id < b.backend_id) {return -1} else {return 1}})

    ContentItem.each do |c|
      c.redirects.each do |r|
        puts r['path'] unless Route.create(
          incoming_path: r['path'],
          route_type: r['type'],
          handler: 'redirect',
          redirect_to: r['destination'],
          redirect_type: r['redirect_type'] || 'permanent',
          segments_mode: r['segments_mode']
        )
      end
      c.routes.each do |r|
        route = { incoming_path: r['path'], route_type: r['type'] };
        if c.schema_name == 'gone'
          route['handler'] = 'gone'
        else
          route['handler'] = 'backend'
          route['backend_id'] = c.rendering_app
        end
        puts r['path'] unless Route.create(route)
      end
    end
  end
end
