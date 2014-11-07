module space.physics.aabb;

import derelict.sdl2.sdl;
import space.utils.mathhelper;
import std.algorithm;
import std.math;
import space.log.log;

class AABB {
public:
	this(double x = 0, double y = 0, double w = 0, double h = 0, double vx = 0, double vy = 0, double speed = 1) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		this.vx = vx;
		this.vy = vy;
		this.speed = speed;
	}

	void Update(double delta, AABB[] hitboxes, SDL_Pointd jumpyness = SDL_Pointd(0, 6)) {
		vx = max(min(vx, 400), -400);
		vy = max(min(vy, 400), -400);

		x += vx*delta;

		foreach(ref box; hitboxes) {
			if (Hit(box)) {
				x -= vx*delta;//*box.Speed;
				if (jumpyness.x == 0/* && box.Speed == 1*/)
					vx = 0;
				else// if (box.Speed == 1)
					vx = -vx/jumpyness.x;
				break;
			}
		}

		Y += vy*delta;

		foreach(ref box; hitboxes) {
			if (Hit(box)) {
				y -= vy*delta*box.Speed;
				if (jumpyness.y == 0 && box.Speed == 1)
					vy = 0;
				else if (box.Speed == 1)
					vy = -vy/jumpyness.y;
				break;
			}
		}
	}

	bool Hit(AABB b) {
		return MathHelper.CheckCollision(Rect(), b.Rect());
	}

	@property ref SDL_Rectd Rect() { return rt = SDL_Rectd(x, y, w, h); };
	@property ref SDL_Pointd Point() { return pt = SDL_Pointd(x, y); };

	@property ref double X() { return x; }
	@property ref double Y() { return y; }
	@property ref double W() { return w; }
	@property ref double H() { return h; }
	@property ref double VX() { return vx; }
	@property ref double VY() { return vy; }
	@property ref double Speed() { return speed; }

private:
	double x, y;
	double w, h;
	double vx, vy;
	double speed;
	SDL_Rectd rt;
	SDL_Pointd pt;


	

}

