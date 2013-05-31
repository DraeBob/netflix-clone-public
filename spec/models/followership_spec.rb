require 'spec_helper'

describe Followership do 
  it { should belong_to(:user) }
  it { should belong_to(:follower), class: 'User' }
end