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
	this(Engine* engine, double scale = 10) {
		this.engine = engine;
		this.bg = new Texture(engine, null, "res/img/background.png");
		this.bgPos1 = bg.Size;
		this.bgPos2 = bg.Size;
		this.bgPos2.x = bgPos2.w;
		this.scale = scale;

		for(int i = 0; i < boxes.length; i++)
			boxes[i] = box(SDL_Pointd(uniform(0, engine.Size.w), uniform(0, engine.Size.h)), uniform(0.0, 1.0));

		this.globe = new Texture(engine, null, "res/img/globe.png");
		this.globe.SetColor(100, 100, 100);
		this.globePos = SDL_Rectd(1366-globe.Size.w/10*5, 768-globe.Size.h/10*4, globe.Size.w/10*5, globe.Size.h/10*4);
	}

	~this() {
		destroy(globe);
		destroy(bg);
	}

	void Update(double delta) {
		bgPos1.x -= delta*scale;
		bgPos2.x -= delta*scale;
		
		if (bgPos1.x <= -1 * bgPos1.w)
			bgPos1.x += bgPos1.w * 2;
		if (bgPos2.x <= -1 * bgPos2.w)
			bgPos2.x += bgPos2.w * 2;

		foreach(ref b; boxes) {
			b.life -= delta/2;
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
		SDL_Rectd tmp = globe.Size;
		tmp.w /= 2;	tmp.h /= 2;
		globe.Render(&tmp, &globePos, false);
	}

	@property ref double Scale() { return scale; }
private:
	Engine* engine;
	Texture bg;
	SDL_Rectd bgPos1;
	SDL_Rectd bgPos2;
	double scale;
	Texture globe;
	SDL_Rectd globePos;

	box[400] boxes;
	struct box {
		SDL_Pointd pos;
		double life;
	}
}

