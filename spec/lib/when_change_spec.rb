require 'spec_helper'

describe "when_change" do
  let(:method){:notify_subsribers}
  let(:attributes){{status: 'published'}}
  before do
    Post.send(:define_method,:notify_subsribers, ->{true})
  end
  it "should be respond_to the model" do
    Post.should respond_to(:when_change)
    Post.new.should respond_to(:when_change)
  end
  context "when model defined some when_change event" do
    context "whem its defined inside after_create" do
      before do
        Post.reset_callbacks(:update)

        Post.after_create do
          when_change :status, from: :draft, to: :published do
            notify_subsribers
          end
        end
      end
      let(:post){Post.new(status: :draft)}
      it_behaves_like "callback not triggered"
    end

    context "whem its defined inside after_update" do
      before do
        Post.reset_callbacks(:update)
        Post.after_update do
          when_change :status, from: 'draft', to: 'published' do
            notify_subsribers
          end
        end
      end
      let(:post){Post.create(status: 'draft')}
      it_behaves_like "callback triggered"
      context "when if" do
        context "when true" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, if: 'true' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: :draft)}
          it_behaves_like "callback triggered"
        end
        context "when false" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, if: 'false' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: :draft)}
          it_behaves_like "callback not triggered"
        end
      end
      context "when unless" do
        context "when true" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, unless: 'true' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: :draft)}
          it_behaves_like "callback not triggered"
        end
        context "when false" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, unless: 'false' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: :draft)}
          it_behaves_like "callback triggered"
        end
      end
      context "when :to" do
        context "when :to same as previous" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, from: 'true' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: 'published')}
          it_behaves_like "callback not triggered"
        end
        context "when :to same diff with previous" do
          before do
            Post.reset_callbacks(:update)
            Post.after_update do
              when_change :status, unless: 'false' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: 'draft')}
          it_behaves_like "callback triggered"
        end
      end
    end

  end

end
