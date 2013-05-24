require 'spec_helper'

describe User do 
  it { should have_many(:reviews) }
  it { should validate_presence_of(:fullname) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should have_many(:queue_videos).order(:position) }
end