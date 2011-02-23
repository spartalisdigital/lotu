shared_examples_for "system user" do
  it{ @user.should be_kind_of Lotu::SystemUser }
  describe "the user class" do
    it{ @user.class.should respond_to :use }
  end
end

shared_examples_for "resource manager" do
  it{ @user.should be_kind_of Lotu::ResourceManager }
  it{ @user.should respond_to :image }
  it{ @user.should respond_to :images }
  it{ @user.should respond_to :sound }
  it{ @user.should respond_to :sounds }
  it{ @user.should respond_to :song }
  it{ @user.should respond_to :songs }
  it{ @user.should respond_to :animation }
  it{ @user.should respond_to :animations }
  it{ @user.should respond_to :load_images }
  it{ @user.should respond_to :load_sounds }
  it{ @user.should respond_to :load_songs }
  it{ @user.should respond_to :load_animations }
end
