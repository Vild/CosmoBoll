module space.graphics.text;

import space.graphics.texture;
import space.log.log;

import derelict.sdl2.sdl;

class Text {
public:
	this(SDL_Renderer* renderer, string text, double scale = 1.0) {
		if (font is null)
			font = new Texture(renderer, "res/img/font.png");

		this.text = text;
		this.scale = scale;
	}

	void Render(SDL_Rect* dst) {
		SDL_Rect src;
		src.w = font.Size.w / 16;
		src.h = font.Size.h / 16;
		SDL_Rect newdst = SDL_Rect(dst.x, dst.y, cast(int)(src.w*scale), cast(int)(src.h*scale));
		foreach(char c; text) {
			//Font image is a grid of 16x16=256
			src.x = (c % 16)*src.w;
			src.y = (c / 16)*src.h;

			font.Render(&src, &newdst);
			newdst.x += newdst.w;
		}
	}

	@property ref string Text() { return text; }
	@property ref double Scale() { return scale; }

private:
	static Texture font = null;;
	string text;
	double scale;
}

