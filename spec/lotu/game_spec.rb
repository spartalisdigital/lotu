require 'lotu'

describe "Game" do
  it_should_behave_like "system user"
  it_should_behave_like "resource user"

  before :all do
    @game = Lotu::Game.new #:debug => true
    @game.with_path_from_file(__FILE__) do |g|
      load_images '../../examples/media/images'
    end

    @user = @game
  end

  it{ @game.should respond_to :update }
  it{ @game.should respond_to :draw }
  it{ @game.should respond_to :dt }
  it{ @game.should respond_to :update_queue }
  it{ @game.should respond_to :draw_queue }
  it{ @game.should respond_to :image }
  it{ @game.should respond_to :sound }
  it{ @game.should respond_to :song }
  it{ @game.should respond_to :animation }
  it{ @game.should respond_to :load_images }
  it{ @game.should respond_to :load_sounds }
  it{ @game.should respond_to :load_songs }
  it{ @game.should respond_to :load_animations }
  it{ @game.should respond_to :fps }

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
