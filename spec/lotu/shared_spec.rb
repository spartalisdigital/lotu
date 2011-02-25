shared_examples_for "system user" do
  it{ @user.should be_kind_of Lotu::SystemUser }
  describe "the user class" do
    it{ @user.class.should respond_to :use }
  end
end

shared_examples_for "eventful" do
  it{ @user.should be_kind_of Lotu::Eventful }
  it{ @user.should respond_to :on }
  it{ @user.should respond_to :fire }
end

shared_examples_for "collidable" do
  it{ @user.should be_kind_of Lotu::Collidable }
  it{ @user.should respond_to :collides_with? }
  describe "the user class" do
    it{ @user.class.should respond_to :collides_as }
  end
end

shared_examples_for "controllable" do
  it{ @user.should be_kind_of Lotu::Controllable }
  it{ @user.should respond_to :set_keys }
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
