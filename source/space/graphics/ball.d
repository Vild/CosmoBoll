module space.graphics.ball;

import space.engine;
import space.graphics.texture;
import space.log.log;
import space.physics.aabb;
import space.utils.mathhelper;

class Ball {
public:
	this(Engine* engine, Texture tex, AABB pos, SDL_Pointd[] poses) {
		this.engine = engine;
		this.tex = tex;
		this.pos = pos;
		this.poses = poses;
		this.poses ~= pos.Point;
		this.isHooked = false;
		this.pos.ApplySpeed = true;
	}

	~this() {
		destroy(poses);
		destroy(pos);
		destroy(tex);
	}

	void Update(double delta, double speed, double gravity, AABB[] colideWith) {
		if (isHooked)
			return;
		double dvx = 0;
		double dvy = 0;
		rot += delta;
		
		dvy += gravity;

		pos.Update(delta, dvx, dvy, colideWith, SDL_Pointd(2, 3));
	}
	
	void Render() {
		tex.Render(null, &pos.Rect(), false);
	}

	void Respawn() {
		import std.random;
		SDL_Pointd newpos = poses[uniform(0, poses.length)];
		pos.X = newpos.x;
		pos.Y = newpos.y;
		pos.VX = 0;
		pos.VY = 0;
		isHooked = false;
	}

	@property ref AABB Pos() { return pos; }
	@property ref bool IsHooked() { return isHooked; }
private:
	Engine* engine;
	Texture tex;
	AABB pos;
	SDL_Pointd[] poses;
	bool isHooked;
	double rot;
}
