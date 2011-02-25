require 'lotu'

class Actress < Lotu::Actor
  collides_as :actress_in_distress
  use Lotu::SteeringSystem
end

class Fan < Actress
  use Lotu::StalkerSystem
end

describe "Actor" do

  before :each do
    @game = Lotu::Game.new(:parse_cli_options => false)
    @actor = Lotu::Actor.new
    @actress = Actress.new
    @fan = Fan.new
    @user = @actor
  end

  after :each do
    @actor.die
    @actress.die
    @fan.die
  end

  describe "When just created" do
    it "should have the appropiate number of systems" do
      @actor.systems.length.should be 0
    end

    it "should have the appropiate type of systems" do
      @actor.systems.keys.should == []
    end

    it "should have the appropiate behavior options set" do
      @actor.class.behavior_options.should == {}
    end

    it "#x == 0" do
      @actor.x.should == 0
    end

    it "#y == 0" do
      @actor.y.should == 0
    end

    it "#z == 0" do
      @actor.z.should == 0
    end
  end

  describe "Behavior" do
    it_should_behave_like "system user"
    it_should_behave_like "eventful"
    it_should_behave_like "collidable"
    it_should_behave_like "controllable"
  end

  describe "Actor subclasses" do
    before :each do
      @user = @actress
    end

    describe "Behavior" do
      it_should_behave_like "system user"
      it_should_behave_like "eventful"
      it_should_behave_like "collidable"
      it_should_behave_like "controllable"
    end

    it "should have a different object hash for behavior_options" do
      @user.class.behavior_options.should_not be @actor.class.behavior_options
    end

    it "should have different values in behavior_options" do
      @user.class.behavior_options.should_not == @actor.class.behavior_options
    end

    describe "When just created" do
      it "should have the appropiate number of systems" do
        @user.systems.length.should be 1
      end

      it "should have the appropiate type of systems" do
        @user.systems.keys.should == [Lotu::SteeringSystem]
      end

      it "should have the appropiate behavior options set" do
        @user.class.behavior_options.should == {Lotu::Collidable=>{:actress_in_distress=>{}},
          Lotu::SystemUser=>{Lotu::SteeringSystem=>{}}}
      end

      it "#x == 0" do
        @user.x.should == 0
      end

      it "#y == 0" do
        @user.y.should == 0
      end

      it "#z == 0" do
        @user.z.should == 0
      end
    end
  end

  describe "Basic methods and properties" do
    it{ @actor.should respond_to :x }
    it{ @actor.should respond_to :y }
    it{ @actor.should respond_to :parent }
    it{ @actor.should respond_to :color }
  end
end
