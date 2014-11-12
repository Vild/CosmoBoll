module space.graphics.player;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.ball;
import space.graphics.texture;
import space.io.keyboard;
import space.log.log;
import space.physics.aabb;
import space.utils.mathhelper;
import std.math;
import space.music.song;

class Player {
public:
	this(Engine* engine, SDL_Color color, AABB pos, SDL_Scancode up, SDL_Scancode down, SDL_Scancode left, SDL_Scancode right, SDL_Scancode action) {
		this.engine = engine;
		this.idle = new Texture(engine, null, "res/img/man/idle.png");
		this.run = new AnimatedTexture(engine, null, [
			"res/img/man/run1.png", "res/img/man/run2.png", "res/img/man/run3.png", "res/img/man/run4.png", "res/img/man/run5.png", 
			"res/img/man/run6.png", "res/img/man/run7.png", "res/img/man/run8.png", "res/img/man/run9.png", "res/img/man/run10.png", 
			"res/img/man/run11.png", "res/img/man/run12.png", "res/img/man/run13.png"], 0.08);
		this.fly = new AnimatedTexture(engine, null, [
			"res/img/man/fly1.png", "res/img/man/fly2.png", "res/img/man/fly3.png"], 0.08);
		this.color = color;
		this.idle.SetColor(color.r, color.g, color.b);
		this.run.SetColor(color.r, color.g, color.b);
		this.fly.SetColor(color.r, color.g, color.b);
		this.pos = pos;
		this.orgpos = pos.Point;
		this.jetpack = new Song("res/song/jetpack.wav");
		this.jetpack.SetVolume(15);

		this.lookLeft = false;

		this.up = up;
		this.down = down;
		this.left = left;
		this.right = right;
		this.action = action;
	}

	~this() {
		destroy(jetpack);
		destroy(pos);
		destroy(fly);
		destroy(run);
		destroy(idle);
	}

	void Update(double delta, double speed, double gravity, AABB[] colideWith, Ball* ball) {
		Keyboard k = engine.KeyboardState;
		double dvx = 0;
		double dvy = 0;

		dvy += gravity;
		
		dvx -= pos.VX*delta*1.15;

		if (k.isDown(up)) {
			if (pos.VY.abs < MOVEMENT_THRESHOLD)
				didJump = 0;//.5*3;
			dvy -= delta*speed;
		}
		if (k.isDown(down))
			dvy += delta*speed;
		if (k.isDown(left)) {
			dvx -= delta*speed;
			lookLeft = true;
		}
		if (k.isDown(right)) {
			dvx += delta*speed;
			lookLeft = false;
		}

		if (k.isJustPressed(action)) {
			if (hookedBall is null) {
				if (pos.Hit(ball.Pos)) {
					hookedBall = ball;
					hookedBall.IsHooked = true;
					prepareForShoot = false;
				}
			} else
				prepareForShoot = true;
		}

		if (k.getJustLeftGo(action) > 0 && hookedBall !is null && (prepareForShoot || k.getJustLeftGo(action) > 1)) {
			double degree = (lookLeft) ? 180 : 0;
			double bvx = cos(degree*PI/180)*speed*(0.5+k.getJustLeftGo(action))*0.75;
			double bvy = sin(degree*PI/180)*speed*(0.5+k.getJustLeftGo(action))*0.75;


			hookedBall.Pos.Update(delta, bvx, bvy, colideWith);
			hookedBall.IsHooked = false;
			hookedBall = null;
		}

		if (hookedBall !is null) {
			hookedBall.Pos.VX = pos.VX;
			hookedBall.Pos.VY = pos.VY;
			hookedBall.IsHooked = true;
			hookedBall.Pos.Update(delta, 0, 0, colideWith);
			if (pos.LengthTo(hookedBall.Pos) > 200) {
				hookedBall.IsHooked = false;
				hookedBall = null;
			}
		}
		pos.Update(delta, dvx, dvy, colideWith);

		if (pos.VX.abs < MOVEMENT_THRESHOLD && pos.VY.abs < MOVEMENT_THRESHOLD) {
			idle.Update(delta);
			jetpack.Stop();
		} else {
			idle.Reset();
			if (pos.VY.abs < MOVEMENT_THRESHOLD) {
				run.Update(delta);
				jetpack.Stop();
			} else {
				run.Reset();
				fly.Update(delta); //FIXME: Reset me sometime maybe?
				jetpack.Play(-1);
			}
		}
	}

	void Render() {
		if (pos.VX.abs < MOVEMENT_THRESHOLD && pos.VY.abs < MOVEMENT_THRESHOLD)
			idle.Render(null, &pos.Rect(), false, 0, lookLeft ? SDL_FLIP_HORIZONTAL : SDL_FLIP_NONE);
		else if (pos.VY.abs < MOVEMENT_THRESHOLD)
			run.Render(null, &pos.Rect(), false, 0, lookLeft ? SDL_FLIP_HORIZONTAL : SDL_FLIP_NONE);
		else
			fly.Render(null, &pos.Rect(), false, 0, lookLeft ? SDL_FLIP_HORIZONTAL : SDL_FLIP_NONE);
		if (hookedBall !is null) {
			SDL_SetRenderDrawColor(engine.Renderer, color.r, color.g, color.b, 200);
			double lx = pos.X+pos.W/2;
			if (lookLeft)
				lx -= 5;
			else
				lx += 5;

			SDL_RenderDrawLine(engine.Renderer, cast(int)(lx-1), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2-1), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
			SDL_RenderDrawLine(engine.Renderer, cast(int)(lx), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
			SDL_RenderDrawLine(engine.Renderer, cast(int)(lx+1), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2+1), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
		}

	}

	void Respawn() {
		pos.X = orgpos.x;
		pos.Y = orgpos.y;
		pos.VX = 0;
		pos.VY = 0;
		if (hookedBall !is null) {
			hookedBall.IsHooked = false;
			hookedBall = null;
		}
	}

	@property ref bool LookLeft() { return lookLeft; }
	@property ref AABB Pos() { return pos; }
	@property ref Ball* HookedBall() { return hookedBall; }

private:
	Engine* engine;
	Texture idle;
	Texture run;
	Texture fly;
	SDL_Color color;
	AABB pos;
	SDL_Pointd orgpos;
	Song jetpack;

	bool lookLeft;
	Ball* hookedBall;
	bool prepareForShoot;

	double didJump;
	bool isFlying;

	SDL_Scancode up, down, left, right, action;

	enum MOVEMENT_THRESHOLD = 3;
}
