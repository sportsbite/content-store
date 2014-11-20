class RegisterableGoneRoute < RegisterableRoute
  def initialize(attrs)
    super attrs.stringify_keys.except('rendering_app')
  end

  def register!
    Rails.application.router_api.add_gone_route(path, type)
  end
end
