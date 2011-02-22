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

%Q{
1.upto(100) do |i|
   if i % 3 == 0 || i % 5 == 0
     print 'Fizz' if i % 3 == 0
     print 'Buzz' if i % 5 == 0
   else
    print i
   end
   print "\n"
end
}.size
