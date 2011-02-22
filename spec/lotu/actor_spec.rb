require 'lotu'

describe "Actor" do
  before :each do
    @game = Lotu::Game.new
    @actor = Lotu::Actor.new
  end

  after :each do
    @actor.die
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
