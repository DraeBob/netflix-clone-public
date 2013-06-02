require 'spec_helper'

feature 'Followership' do
  let(:ann){ Fabricate(:user) }
  let(:bob) { Fabricate(:user) }
  let(:cat) { Fabricate(:category, name: "Comedy")}
  let(:video) { Fabricate(:video, categories: [cat]) }
  let(:review) { Fabricate(:review, video: video, user: bob) }

  scenario "ann folllow and unfollow bob" do
    sign_in(ann)
    visit video_path(video)
    page.should have_content bob.fullname
    click_on bob.fullname

    click_link "Follow"
    page.should have_content "Followership created"
    page.should have_content bob.fullname
    unfollow(bob)
  end

  def unfollow(user)
    within(:xpath, "//tr[contains(.,'#{user.fullname}')]") do
      find("a[data-method='delete']").click
    end
    page.should_not have_content user.fullname
  end
end