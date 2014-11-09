module space.graphics.player;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.ball;
import space.graphics.texture;
import space.io.keyboard;
import space.physics.aabb;
import std.math;

class Player {
public:
	this(Engine* engine, SDL_Color color, AABB pos, SDL_Scancode up, SDL_Scancode down, SDL_Scancode left, SDL_Scancode right, SDL_Scancode shootLeft, SDL_Scancode shootRight, SDL_Scancode action) {
		this.engine = engine;
		//res/img/man/idle.png
		this.tex = new AnimatedTexture(engine, null, [
			"res/img/man/run1.png", "res/img/man/run2.png", "res/img/man/run3.png", "res/img/man/run4.png", "res/img/man/run5.png", 
			"res/img/man/run6.png", "res/img/man/run7.png", "res/img/man/run8.png", "res/img/man/run9.png", "res/img/man/run10.png", 
			"res/img/man/run11.png", "res/img/man/run12.png", "res/img/man/run13.png"], 0.08);
		this.tex.SetColor(color.r, color.g, color.b);
		this.pos = pos;

		this.lookLeft = false;

		this.up = up;
		this.down = down;
		this.left = left;
		this.right = right;

		this.shootLeft = shootLeft;
		this.shootRight = shootRight;
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
		if (k.isJustPressed(shootLeft)) {
			if (hookedBall is null) {
				if (pos.Hit(ball.Pos)) {
					hookedBall = ball;
					hookedBall.IsHooked = true;
				}
			}
		}

		if (k.isJustPressed(shootRight)) {
			if (hookedBall is null) {
				if (pos.Hit(ball.Pos)) {
					hookedBall = ball;
					hookedBall.IsHooked = true;
				}
			}
		}

		
		if (k.getJustLeftGo(shootLeft) > 0 && hookedBall !is null) {
			double bvx = cos((90+45)*PI/180);
			double bvy = sin((90+45)*PI/180);
			
			hookedBall.Pos.Update(delta, bvx, bvy, colideWith);
			hookedBall.IsHooked = false;
			hookedBall = null;
		}
		
		if (k.getJustLeftGo(shootRight) > 0 && hookedBall !is null) {
			double bvx = cos((45)*PI/180)*speed/2;
			double bvy = sin((45)*PI/180)*speed/2;
			
			hookedBall.Pos.Update(delta, bvx, bvy, colideWith);
			hookedBall.IsHooked = false;
			hookedBall = null;
		}

		//TODO: Do something for action
		if (hookedBall !is null)
			hookedBall.Pos.Update(delta, dvx, dvy, colideWith);
		pos.Update(delta, dvx, dvy, colideWith);
		tex.Update(delta);
	}

	void Render() {
		tex.Render(null, &pos.Rect(), false, 0, lookLeft ? SDL_FLIP_HORIZONTAL: SDL_FLIP_NONE);
	}

	@property ref bool LookLeft() { return lookLeft; }
	@property ref AABB Pos() { return pos; }
	@property ref Ball* HookedBall() { return hookedBall; }

private:
	Engine* engine;
	Texture tex;
	AABB pos;

	bool lookLeft;
	Ball* hookedBall;

	SDL_Scancode up, down, left, right;
	SDL_Scancode shootLeft, shootRight, action;
}

