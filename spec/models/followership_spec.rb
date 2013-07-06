require 'spec_helper'

describe Followership do 
  it { should belong_to(:follower)}
  it { should belong_to(:followee)}
end