# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lotu}
  s.version = "0.1.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["lobo_tuerto"]
  s.date = %q{2010-03-25}
  s.description = %q{lotu aims to bring an agile and simple game development framework to life. It provides useful abstractions so you can concentrate on developing your game.}
  s.email = %q{dev@lobotuerto.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc",
     "TODO"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "examples/hello_world/hello_world.rb",
     "examples/media/Beep.wav",
     "examples/media/CptnRuby Gem.png",
     "examples/media/CptnRuby Map.txt",
     "examples/media/CptnRuby Tileset.png",
     "examples/media/CptnRuby.png",
     "examples/media/Cursor.png",
     "examples/media/Earth.png",
     "examples/media/Explosion.wav",
     "examples/media/LargeStar.png",
     "examples/media/Smoke.png",
     "examples/media/Soldier.png",
     "examples/media/Space.png",
     "examples/media/Star.png",
     "examples/media/Starfighter.bmp",
     "examples/media/amenoske.png",
     "examples/media/crosshair.png",
     "examples/media/lobo_tuerto.png",
     "examples/media/title.png",
     "examples/mouse_pointer/mouse_pointer.rb",
     "examples/steering_behaviors/steering.rb",
     "lib/lotu.rb",
     "lib/lotu/actor.rb",
     "lib/lotu/behaviors/collidable.rb",
     "lib/lotu/behaviors/controllable.rb",
     "lib/lotu/behaviors/controllable/input_controller.rb",
     "lib/lotu/behaviors/drawable.rb",
     "lib/lotu/behaviors/eventful.rb",
     "lib/lotu/cursor.rb",
     "lib/lotu/misc/vector2d.rb",
     "lib/lotu/text_box.rb",
     "lib/lotu/window.rb",
     "lotu.gemspec",
     "test/actor_test.rb"
  ]
  s.homepage = %q{http://github.com/lobo-tuerto/lotu}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A simple, agile Ruby game development framework.}
  s.test_files = [
    "test/actor_test.rb",
     "examples/steering_behaviors/steering.rb",
     "examples/hello_world/hello_world.rb",
     "examples/mouse_pointer/mouse_pointer.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gosu>, [">= 0.7.18"])
    else
      s.add_dependency(%q<gosu>, [">= 0.7.18"])
    end
  else
    s.add_dependency(%q<gosu>, [">= 0.7.18"])
  end
end

