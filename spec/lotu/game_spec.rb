require 'lotu'

describe "Game" do
  before :each do
    @game = Lotu::Game.new
  end

  it{ @game.should respond_to :close }
  it{ @game.should respond_to :update }
  it{ @game.should respond_to :draw }

  describe "every game tick" do
    before :each do
      @actor = Lotu::Actor.new
    end

    after :each do
      @actor.die
    end

    it "should call #update on actors" do
      @actor.should_receive :update
      @game.update
    end

    it "should call #draw on actors" do
      @actor.should_receive :draw
      @game.draw
    end
  end

end
