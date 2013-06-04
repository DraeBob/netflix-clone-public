require 'spec_helper'

describe Followership do 
  it { should belong_to(:follower), class: 'User' }
  it { should belong_to(:followee), class: 'User' }
end