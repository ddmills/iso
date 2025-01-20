package domain;

import common.struct.FloatPoint3;
import common.tools.Performance;
import core.Game;
import data.input.InputGroups;
import domain.AiManager.AIManager;
import domain.Clock.ClockSave;
import domain.PlayerManager.PlayerSave;
import domain.map.MapData;
import domain.map.MapGenerator;
import hxd.Rand;

typedef WorldSave =
{
	public var seed:Int;
	public var clock:ClockSave;
	public var player:PlayerSave;
}

class World
{
	public var game(get, null):Game;
	public var clock(default, null):Clock;
	public var systems(default, null):SystemManager;
	public var player(default, null):PlayerManager;
	public var ai(default, null):AIManager;
	public var map(default, null):MapData;
	public var seed:Int = 2;
	public var rand:Rand;
	public var input:InputGroups;

	public function new()
	{
		clock = new Clock();
		systems = new SystemManager();
		player = new PlayerManager();
		ai = new AIManager();
		input = new InputGroups();
		map = new MapData();
	}

	public function initialize()
	{
		rand = new Rand(seed);
		systems.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}

	public function newGame(seed:Int)
	{
		this.seed = seed;
		rand = new Rand(seed);

		generateMap();

		// var pos = new FloatPoint3((map.width / 2).floor() + .5, (map.height / 2) + .5, 0);
		var pos = new FloatPoint3(0 + .5, 0 + .5, 1);
		player.create(pos);
	}

	public function generateMap()
	{
		map?.ob.remove();
		map = new MapData();

		var gen = new MapGenerator();
		map = gen.generate({
			seed: seed
		});

		// game.render(GROUND, map.ob);
	}

	public function load(data:WorldSave)
	{
		Performance.start('world-load');

		seed = data.seed;
		rand = new Rand(seed);
		clock.load(data.clock);
		player.load(data.player);

		Performance.stop('world-load', true);
	}

	public function save(teardown:Bool = false):WorldSave
	{
		Performance.start('world-save');

		var s = {
			seed: seed,
			clock: clock.save(),
			player: player.save(teardown),
		};

		Performance.stop('world-save', true);

		return s;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}
}
