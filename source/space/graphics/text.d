module space.graphics.text;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.texture;
import space.log.log;
import space.utils.mathhelper;
import std.array;

class Text {
public:
	this(Engine* engine, string text, double scale = 1.0) {
		font = new Texture(engine, null, "res/img/font.png");

		this.text = text;
		this.scale = scale;

		this.SetColor(SDL_Color(255, 255, 255, 255), SDL_Color(255, 255, 255, 0));
	}

	~this() {
		destroy(font);
	}

	void Render(SDL_Rectd* dst) {
		SDL_Rectd tmp = *dst;
		font.SetColor(under.r, under.g, under.b);
		font.SetAlpha(under.a);
		tmp.x += 8;
		tmp.y -= 8;
		textRender(&tmp);
		font.SetColor(over.r, over.g, over.b);
		font.SetAlpha(over.a);
		tmp.x -= 8;
		tmp.y += 8;
		textRender(&tmp);
	}

	@property ref string Text() { return text; }
	@property ref double Scale() { return scale; }
	@property SDL_Rectd Size() {
		string tmptext = text.replace("å", "\xFC").replace("ä", "\xFD").replace("ö", "\xFE");
		return SDL_Rectd(0.0, 0.0,
		       			(font.Size.w / 16.0) * scale * tmptext.length,
		                (font.Size.h / 16.0) * scale);
	}
	void SetColor(SDL_Color over, SDL_Color under) {
		this.over = over;
		this.under = under;
	}
private:
	Texture font = null;
	string text;
	double scale;
	SDL_Color over, under;

	void textRender(SDL_Rectd* dst) {
		SDL_Rectd src;
		src.w = font.Size.w / 16;
		src.h = font.Size.h / 16;
		SDL_Rectd ndst = SDL_Rectd(dst);
		ndst.w = src.w * scale;
		ndst.h = src.h * scale;
		string tmptext = text.replace("å", "\xFC").replace("ä", "\xFD").replace("ö", "\xFE");
		foreach(char c; tmptext) {
			//Font image is a grid of 16x16=256
			src.x = (c % 16)*src.w;
			src.y = (c / 16)*src.h;
			font.Render(&src, &ndst, false);
			
			ndst.x += ndst.w;
		}
	}
}

