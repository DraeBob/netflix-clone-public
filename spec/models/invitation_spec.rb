require 'spec_helper'

describe Invitation do 
  it { should belong_to(:inviter), class: 'User' }

  it { should validate_presence_of(:friend_email) }
  it { should validate_presence_of(:friend_name) }
  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:inviter_id) }
end