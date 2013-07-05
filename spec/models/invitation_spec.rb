require 'spec_helper'

describe Invitation do 
  it { should belong_to(:inviter) }

  it { should validate_presence_of(:friend_email) }
  it { should validate_presence_of(:friend_name) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:inviter_id) }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end
end