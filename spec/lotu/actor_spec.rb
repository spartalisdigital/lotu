require 'lotu'

class Actress < Lotu::Actor
  use Lotu::SteeringSystem
end

describe "Actor" do

  before :each do
    @game = Lotu::Game.new
    @actor = Lotu::Actor.new
    @actress = Actress.new
    @user = @actor
  end

  after :each do
    @actor.die
  end

  describe "Behavior" do
    it_should_behave_like "system user"
    it_should_behave_like "eventful"
    it_should_behave_like "collidable"
    it_should_behave_like "controllable"
  end

  describe "Descendants" do
    it "should have a different object hash for behavior_options" do
      @actress.class.behavior_options[Actress].should_not be @actor.class.behavior_options[Lotu::Actor]
    end

    it "should have different values in behavior_options" do
      @actress.class.behavior_options[Actress].should_not == @actor.class.behavior_options[Lotu::Actor]
    end
  end

  it "should have the appropiate number of systems" do
    @actor.systems.length.should be 2
  end

  it "should have the appropiate type of systems" do
    @actor.systems.keys.should == [Lotu::AnimationSystem, Lotu::InterpolationSystem]
  end

  it "should have the appropiate behavior options set" do
    @actor.class.behavior_options.should == {Lotu::SystemUser=>{Lotu::AnimationSystem=>{}, Lotu::InterpolationSystem=>{}}, Lotu::Collidable=>{}}
  end

  it{ @actor.should respond_to :x }
  it{ @actor.should respond_to :y }
  it{ @actor.should respond_to :parent }
  it{ @actor.should respond_to :color }

  describe "at creation" do
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
  
end
