module space.graphics.text;

import space.graphics.texture;
import space.log.log;

import derelict.sdl2.sdl;

class Text {
public:
	this(SDL_Renderer* renderer, string text, double scale = 1.0) {
		font = new Texture(renderer, "res/img/font.png");

		this.text = text;
		this.scale = scale;
	}

	~this() {
		destroy(font);
	}

	void Render(SDL_Rect* dst) {
		SDL_Rect src;
		src.w = font.Size.w / 16;
		src.h = font.Size.h / 16;
		double[4] newdst = [dst.x, dst.y, cast(double)src.w*scale, cast(double)src.h*scale];

		foreach(char c; text) {
			//Font image is a grid of 16x16=256
			src.x = (c % 16)*src.w;
			src.y = (c / 16)*src.h;
			SDL_Rect ndst = SDL_Rect(cast(int)newdst[0], cast(int)newdst[1], cast(int)newdst[2], cast(int)newdst[3]);
			font.Render(&src, &ndst);
			newdst[0] += newdst[2];
		}
	}

	@property ref string Text() { return text; }
	@property ref double Scale() { return scale; }
	@property SDL_Rect Size() {
		return SDL_Rect(0, 0,
		       			cast(int)((font.Size.w / 16.0) * scale * cast(double)text.length),
		                cast(int)((font.Size.h / 16.0) * scale));
	}
	void SetColor(ubyte r, ubyte b, ubyte g, ubyte a = 255) {
		font.SetColor(r, b, g);
		font.SetAlpha(a);
	}
private:
	Texture font = null;;
	string text;
	double scale;
}

