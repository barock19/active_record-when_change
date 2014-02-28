shared_examples "callback triggered" do
  it "should triggered the calback" do
    mock(post, method).times(1)
    post.update_attributes(attributes)
  end
end
shared_examples "callback not triggered" do
  it "should triggered the calback" do
    mock(post, method).times(0)
    post.update_attributes(attributes)
  end
end