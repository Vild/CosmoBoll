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

class Player {
public:
	this(Engine* engine, SDL_Color color, AABB pos, SDL_Scancode up, SDL_Scancode down, SDL_Scancode left, SDL_Scancode right, SDL_Scancode action) {
		this.engine = engine;
		//res/img/man/idle.png
		this.tex = new AnimatedTexture(engine, null, [
			"res/img/man/run1.png", "res/img/man/run2.png", "res/img/man/run3.png", "res/img/man/run4.png", "res/img/man/run5.png", 
			"res/img/man/run6.png", "res/img/man/run7.png", "res/img/man/run8.png", "res/img/man/run9.png", "res/img/man/run10.png", 
			"res/img/man/run11.png", "res/img/man/run12.png", "res/img/man/run13.png"], 0.08);
		this.color = color;
		this.tex.SetColor(color.r, color.g, color.b);
		this.pos = pos;
		this.orgpos = pos.Point;

		this.lookLeft = false;

		this.up = up;
		this.down = down;
		this.left = left;
		this.right = right;
		this.action = action;
	}

	void Update(double delta, double speed, double gravity, AABB[] colideWith, Ball* ball) {
		Keyboard k = engine.KeyboardState;
		double dvx = 0;
		double dvy = 0;

		dvy += gravity;
		
		dvx -= pos.VX*delta*1.15;

		if (k.isDown(up))
			dvy -= delta*speed;
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
			double degree = (lookLeft) ? 180+45 : 180+90+45;
			double bvx = cos(degree*PI/180)*speed*(0.5+k.getJustLeftGo(action))*0.75;
			double bvy = sin(degree*PI/180)*speed*(0.5+k.getJustLeftGo(action))*0.75;
			
			hookedBall.Pos.Update(delta, bvx, bvy, colideWith);
			hookedBall.IsHooked = false;
			hookedBall = null;
		}

		if (hookedBall !is null) {
			hookedBall.Pos.VX = pos.VX;
			hookedBall.Pos.VY = pos.VY;
			hookedBall.Pos.Update(delta, 0, 0, colideWith);
			if (pos.LengthTo(hookedBall.Pos) > 200) {
				hookedBall.IsHooked = false;
				hookedBall = null;
			}
		}
		pos.Update(delta, dvx, dvy, colideWith);
		tex.Update(delta);
	}

	void Render() {
		tex.Render(null, &pos.Rect(), false, 0, lookLeft ? SDL_FLIP_HORIZONTAL : SDL_FLIP_NONE);
		if (hookedBall !is null) {
			SDL_SetRenderDrawColor(engine.Renderer, color.r, color.g, color.b, 200);
			SDL_RenderDrawLine(engine.Renderer, cast(int)(pos.X+pos.W/2+5-1), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2-1), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
			SDL_RenderDrawLine(engine.Renderer, cast(int)(pos.X+pos.W/2+5), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
			SDL_RenderDrawLine(engine.Renderer, cast(int)(pos.X+pos.W/2+5+1), cast(int)(pos.Y+4), cast(int)(hookedBall.Pos.X+hookedBall.Pos.W/2+1), cast(int)(hookedBall.Pos.Y+hookedBall.Pos.H/2));
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
	Texture tex;
	SDL_Color color;
	AABB pos;
	SDL_Pointd orgpos;

	bool lookLeft;
	Ball* hookedBall;
	bool prepareForShoot;

	SDL_Scancode up, down, left, right, action;
}
