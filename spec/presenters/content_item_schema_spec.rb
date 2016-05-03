require 'rails_helper'
require 'govuk-content-schema-test-helpers'
require 'govuk-content-schema-test-helpers/rspec_matchers'

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'frontend'
  config.project_root = Rails.root
end

describe ContentItemPresenter do
  include GovukContentSchemaTestHelpers::RSpecMatchers

  it "generates a valid content item for a placeholder item" do
    item = create(:content_item, format: "placeholder", content_id: SecureRandom.uuid)

    payload = ContentItemPresenter.new(item, api_url_method).as_json

    expect(payload).to be_valid_against_schema('placeholder')
  end

  let(:api_url_method) do
    lambda { |base_path| "http://api.example.com/content/#{base_path}" }
  end
end
