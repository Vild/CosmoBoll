module space.graphics.scrollingbackground;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.texture;
import space.log.log;
import space.utils.mathhelper;
import std.math;
import std.random;

class ScrollingBackground {
public:
	this(Engine* engine, string background, double scale = 10) {
		this.engine = engine;
		this.bg = new Texture(engine, null, background);
		this.bgPos1 = bg.Size;
		this.bgPos2 = bg.Size;
		this.bgPos2.x = bgPos2.w;
		this.scale = scale;

		for(int i = 0; i < boxes.length; i++)
			boxes[i] = box(SDL_Pointd(uniform(0, engine.Size.w), uniform(0, engine.Size.h)), uniform(0.0, 1.0));
	}

	void Update(double delta) {
		bgPos1.x -= delta*scale;
		bgPos2.x -= delta*scale;
		
		if (bgPos1.x <= -1 * bgPos1.w)
			bgPos1.x += bgPos1.w * 2;
		if (bgPos2.x <= -1 * bgPos2.w)
			bgPos2.x += bgPos2.w * 2;

		foreach(ref b; boxes) {
			b.life -= delta;
			if (b.life <= 0) {
				b.pos.x = cast(int)uniform(0, engine.Size.w);
				b.pos.y = cast(int)uniform(0, engine.Size.h);
				b.life = 1.0;
			}
		}
	}

	void Render() {
		bg.Render(null, &bgPos1, false);
		bg.Render(null, &bgPos2, false);

		//SDL_SetRenderDrawColor(engine.Renderer, 0, 0, 0, 255);
		foreach(b; boxes) { //Todo: change to BlockTexture
			SDL_Rect pos = SDL_Rectd(b.pos.x, b.pos.y, 16, 16).Rect();
			SDL_SetRenderDrawColor(engine.Renderer, 0, 0, 0, cast(ubyte)(255*b.life));
			SDL_RenderFillRect(engine.Renderer, &pos);
		}

	}

	@property ref double Scale() { return scale; }
private:
	Engine* engine;
	Texture bg;
	SDL_Rectd bgPos1;
	SDL_Rectd bgPos2;
	double scale;

	box[600] boxes;
	struct box {
		SDL_Pointd pos;
		double life;
	}
}

