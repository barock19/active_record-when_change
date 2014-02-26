require 'spec_helper'

describe "when_change" do
  it "should be respond_to the model" do
    Post.should respond_to(:when_change)
    Post.new.should respond_to(:when_change)
  end
  context "when model defined some when_change event" do
    after do
      reset_all_constants
    end

    context "whem its defined inside after_create" do
      before do
        Post.class_eval do
          after_create do
            when_change :status, from: :draft, to: :publised do
              notify_subsribers
            end
          end
          after_commit do
            when_change :status, from: :draft, to: :publised do
              notify_subsribers
            end
          end
          def notify_subsribers
            true
          end
        end
      end
      let(:post){Post.new(status: :draft)}
      it "should not triggered the action" do
        post.should respond_to(:notify_subsribers)
        mock(post).notify_subsribers.times(0)
        post.update_attributes status: :publised
      end
    end

    context "whem its defined inside after_update" do
      before do
        Post.class_eval do
          after_update do
            when_change :status, from: :draft, to: :publised do
              notify_subsribers
            end
          end
          def notify_subsribers
            true
          end
        end
      end
      let(:post){Post.create(status: :draft)}
      it "should not triggered the action" do
        post.should respond_to(:notify_subsribers)
        mock(post).notify_subsribers.times(1)
        post.update_attributes status: :publised
      end
    end
  end
  it "should reset constant" do
    Post.new.should_not respond_to(:notify_subsribers)
  end

end
