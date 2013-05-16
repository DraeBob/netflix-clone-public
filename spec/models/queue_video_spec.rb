require 'spec_helper'

describe QueueVideo do 
  it { should belong_to(:user)}
  it { should belong_to(:video)}
end