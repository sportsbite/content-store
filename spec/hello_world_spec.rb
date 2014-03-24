require 'spec_helper'

describe "hello world endpoint" do

  it "should return 'Hello World' on /" do
    response = server_request("/")

    expect(response.code).to eq(200)
    expect(response).to have_response_body("Hello World")
  end
end
