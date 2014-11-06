module space.graphics.text;

import space.graphics.texture;
import space.log.log;

import derelict.sdl2.sdl;
import space.utils.mathhelper;

class Text {
public:
	this(SDL_Renderer* renderer, string text, double scale = 1.0) {
		font = new Texture(renderer, null, "res/img/font.png");

		this.text = text;
		this.scale = scale;
	}

	~this() {
		destroy(font);
	}

	void Render(SDL_Rectd* dst) {
		SDL_Rectd src;
		src.w = font.Size.w / 16;
		src.h = font.Size.h / 16;
		SDL_Rectd ndst = SDL_Rectd(dst);
		ndst.w = src.w * scale;
		ndst.h = src.h * scale;

		foreach(char c; text) {
			//Font image is a grid of 16x16=256
			src.x = (c % 16)*src.w;
			src.y = (c / 16)*src.h;
			font.Render(&src, &ndst, false);
			ndst.x += ndst.w;
		}
	}

	@property ref string Text() { return text; }
	@property ref double Scale() { return scale; }
	@property SDL_Rectd Size() {
		return SDL_Rectd(0.0, 0.0,
		       			(font.Size.w / 16.0) * scale * text.length,
		                (font.Size.h / 16.0) * scale);
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

