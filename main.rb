require 'rubygems'
require 'gosu'

require './lib/game.rb'
require './lib/tile.rb'
require './lib/z.rb'

require './lib/math/rect.rb'

require './lib/engine/game_window.rb'
require './lib/engine/audio_manager.rb'
require './lib/engine/game_state.rb'
require './lib/engine/inexclusive_game_state.rb'
require './lib/engine/game_state_manager.rb'
require './lib/engine/states/menu_state.rb'
require './lib/engine/states/intro_state.rb'
require './lib/engine/states/playing_state.rb'
require './lib/engine/states/dialog_state.rb'
require './lib/engine/states/recap_state.rb'
require './lib/engine/states/high_scores_state.rb'
require './lib/engine/states/help_state.rb'

require './lib/graphics/button.rb'
require './lib/graphics/rendered_text.rb'

require './lib/stage.rb'
require './lib/stages/neanderthal.rb'
require './lib/stages/early_man.rb'
require './lib/stages/warrior.rb'
require './lib/stages/modern_man.rb'
require './lib/stages/ninja.rb'
require './lib/stages/super_man.rb'

require './lib/game_object.rb'
require './lib/objects/enemy.rb'
require './lib/objects/player.rb'
require './lib/objects/projectile.rb'
require './lib/objects/projectiles/arrow.rb'
require './lib/objects/projectiles/bullet.rb'
require './lib/objects/projectiles/throwing_star.rb'

require './lib/objects/pickup.rb'
require './lib/objects/pickups/dna.rb'
require './lib/objects/pickups/healthpack.rb'

$mute = false

GameWindow.new.show