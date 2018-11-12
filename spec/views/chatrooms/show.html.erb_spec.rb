require 'rails_helper'

RSpec.describe "chatrooms/show", type: :view do
  before(:each) do
    @chatroom = assign(:chatroom, Chatroom.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
