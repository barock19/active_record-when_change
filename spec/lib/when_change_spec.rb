require 'spec_helper'

describe "when_change" do
  before do
    Post.send(:define_method,:notify_subsribers, ->{true})
  end
  after do
    Post.reset_callbacks(:update)
  end
  it "should be respond_to the model" do
    Post.should respond_to(:when_change)
    Post.new.should respond_to(:when_change)
  end
  context "when model defined some when_change event" do
    context "whem its defined inside after_create" do
      before do
        Post.after_create do
          when_change :status, from: :draft, to: :publised do
            notify_subsribers
          end
        end
      end
      let(:post){Post.new(status: :draft)}
      it_behaves_like "callback not triggered" do
        let(:method){:notify_subsribers}
        let(:attributes){{status: :publised}}
      end
    end

    context "whem its defined inside after_update" do
      before do
        Post.after_update do
          when_change :status, from: 'draft', to: 'published' do
            notify_subsribers
          end
        end
      end
      let(:post){Post.create(status: 'draft')}
      it "should triggered the calback" do
        mock(post).notify_subsribers.times(1)
        post.update_attributes(status: 'published')
      end
      context "when if" do
        context "when true" do
          before do
            Post.after_update do
              when_change :status, if: 'true' do
                notify_subsribers
              end
            end
          end
          let(:post){Post.create(status: :draft)}
          it_behaves_like "callback triggered" do
            let(:method){:notify_subsribers}
            let(:attributes){{status: :publised}}
          end
        end
        context "when false" do
        end
      end
    end

  end

end
