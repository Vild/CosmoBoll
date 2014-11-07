module space.graphics.forcefield;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.texture;
import space.log.log;
import space.utils.mathhelper;
import space.utils.renderhelper;

class ForceField {
public:
	this(Engine* engine, RenderHelper* renderHelper, string background, SDL_Color color, SDL_Rectd pos, double scale = 8) {
		this.engine = engine;
		this.bg = new Texture(engine, renderHelper, background);
		this.bg.SetAlpha(180);
		this.color = color;
		this.pos = pos;
		this.scale = scale;

		r1 = SDL_Rectd(pos.x, pos.y, pos.w, pos.h);
		r2 = SDL_Rectd(pos.x, pos.y+pos.h, pos.w, 0);
		s1 = SDL_Rectd(0, 0, bg.Size.w, bg.Size.h);
		s2 = SDL_Rectd(0, 0, bg.Size.w, 0);
	}

	void Update(double delta) {
		delta *= scale;
		r1.h -= delta;
		s1.y += delta;

		r2.y -= delta;
		r2.h += delta;
		s2.h += delta;

		if (r2.y <= pos.y) {
			double diff = r2.y-pos.y;
			r1 = SDL_Rectd(pos.x, pos.y, pos.w, pos.h-diff);
			r2 = SDL_Rectd(pos.x, pos.y+pos.h-diff, pos.w, diff);
			s1 = SDL_Rectd(0, diff, bg.Size.w, bg.Size.h);
			s2 = SDL_Rectd(0, 0, bg.Size.w, diff);
		}
	
	}
	
	void Render() {
		bg.Render(&s1, &r1, false);
		bg.Render(&s2, &r2, false);

		SDL_SetRenderDrawColor(engine.Renderer, color.r, color.g, color.b, color.a);
		SDL_Rect tmp = r1.Rect();
		SDL_RenderFillRect(engine.Renderer, &tmp);
		tmp = r2.Rect();
		SDL_RenderFillRect(engine.Renderer, &tmp);

	}


	@property ref double Scale() { return scale; }
private:
	Engine* engine;
	SDL_Color color;
	SDL_Rectd pos;
	Texture bg;
	SDL_Rectd r1;
	SDL_Rectd r2;
	SDL_Rectd s1;
	SDL_Rectd s2;
	double scale;
}

