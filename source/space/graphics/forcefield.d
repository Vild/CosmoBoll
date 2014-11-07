module space.graphics.forcefield;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.texture;
import space.log.log;
import space.utils.mathhelper;
import space.utils.renderhelper;
import space.physics.aabb;

class ForceField {
public:
	this(Engine* engine, RenderHelper* renderHelper, string background, SDL_Color color, SDL_Rectd pos, double scale = 8) {
		this.engine = engine;
		this.bg = new Texture(engine, renderHelper, background);
		this.bg.SetAlpha(180);
		this.color = color;
		this.pos = pos;
		this.scale = scale;

		r1 = new AABB(pos.x, pos.y, pos.w, pos.h, 0, 0, 0.9);
		r2 = new AABB(pos.x, pos.y+pos.h, pos.w, 0, 0, 0.9);
		s1 = SDL_Rectd(0, 0, bg.Size.w, bg.Size.h);
		s2 = SDL_Rectd(0, 0, bg.Size.w, 0);
	}

	void Update(double delta) {
		delta *= scale;
		r1.H -= delta;
		s1.y += delta;

		r2.Y -= delta;
		r2.H += delta;
		s2.h += delta;

		if (r2.Y <= pos.y) {
			double diff = r2.Y-pos.y;
			r1 = new AABB(pos.x, pos.y, pos.w, pos.h-diff, 0, 0, 0.9);
			r2 = new AABB(pos.x, pos.y+pos.h-diff, pos.w, diff, 0, 0, 0.9);
			s1 = SDL_Rectd(0, diff, bg.Size.w, bg.Size.h);
			s2 = SDL_Rectd(0, 0, bg.Size.w, diff);
		}
	
	}
	
	void Render() {
		bg.Render(&s1, &r1.Rect(), false);
		bg.Render(&s2, &r2.Rect(), false);

		SDL_SetRenderDrawColor(engine.Renderer, color.r, color.g, color.b, color.a);
		SDL_Rect tmp = r1.Rect.Rect();
		SDL_RenderFillRect(engine.Renderer, &tmp);
		tmp = r2.Rect.Rect();
		SDL_RenderFillRect(engine.Renderer, &tmp);

	}

	@property ref double Scale() { return scale; }
	@property ref AABB R1() { return r1; }
	@property ref AABB R2() { return r2; }
private:
	Engine* engine;
	SDL_Color color;
	SDL_Rectd pos;
	Texture bg;
	AABB r1;
	AABB r2;
	SDL_Rectd s1;
	SDL_Rectd s2;
	double scale;
}

