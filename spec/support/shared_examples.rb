shared_examples "require_login" do
  it "redirects to the root path" do
    clear_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples "require_valid_token" do
  it "redirect to the expired token path" do
    action
    expect(response).to redirect_to expired_token_path
  end
end

shared_examples "not_send_email_with_invalid_input" do
  it "eamil should be empty" do
    action
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end

shared_examples "send_email_with_valid_input" do
  it "eamil should not to be empty" do
    action
    expect(ActionMailer::Base.deliveries).not_to be_empty
  end
end