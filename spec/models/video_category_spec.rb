require 'spec_helper'

describe VideoCategory do
  it { should belong_to(:category)}
  it { should belong_to(:video)}
end