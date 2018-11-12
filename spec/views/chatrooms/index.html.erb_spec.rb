require 'rails_helper'

RSpec.describe "chatrooms/index", type: :view do
  before(:each) do
    assign(:chatrooms, [
      Chatroom.create!(),
      Chatroom.create!()
    ])
  end

  it "renders a list of chatrooms" do
    render
  end
end
