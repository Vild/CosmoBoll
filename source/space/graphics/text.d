module space.graphics.text;

import derelict.sdl2.sdl;
import space.engine;
import space.graphics.texture;
import space.log.log;
import space.utils.mathhelper;
import std.array;
import std.string;
import std.algorithm;

class Text {
public:
	this(Engine* engine, string text, double scale = 1.0, int maxWidth = 1200) {
		font = new Texture(engine, null, "res/img/font.png");

		this.text = text;
		this.maxWidth = maxWidth;
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
		tmp.x += 1*scale;
		tmp.y -= 1*scale;
		textRender(&tmp);
		font.SetColor(over.r, over.g, over.b);
		font.SetAlpha(over.a);
		tmp.x -= 1*scale;
		tmp.y += 1*scale;
		textRender(&tmp);
	}

	@property ref string Text() { return text; }
	@property ref double Scale() { return scale; }
	@property SDL_Rectd Size() {
		import std.algorithm : min;
		string tmptext = text.replace("å", "\xFC").replace("ä", "\xFD").replace("ö", "\xFE");
		return SDL_Rectd(0.0, 0.0,
		       			min((font.Size.w / 16.0) * scale * tmptext.length, maxWidth),
		                (font.Size.h / 16.0) * scale);
	}
	void SetColor(SDL_Color over, SDL_Color under) {
		this.over = over;
		this.under = under;
	}
private:
	Texture font = null;
	string text;
	int maxWidth;
	double scale;
	SDL_Color over, under;

	void textRender(SDL_Rectd* dst) {
		SDL_Rectd src;
		src.w = font.Size.w / 16;
		src.h = font.Size.h / 16;
		SDL_Rectd ndst = SDL_Rectd(dst);
		ndst.w = src.w * scale;
		ndst.h = src.h * scale;
		string[] tmptext = textSpliter((text ~ " " /* TODO: FIX this ugly hack */).replace("å", "\xFC").replace("ä", "\xFD").replace("ö", "\xFE"));

		foreach (string line; tmptext) {
			foreach (char c; line) {
				//Font image is a grid of 16x16=256
				src.x = (c % 16)*src.w;
				src.y = (c / 16)*src.h;
				font.Render(&src, &ndst, false);
				
				ndst.x += ndst.w;
			}
			ndst.y += ndst.h + (src.w/2)*scale;
			ndst.x -= line.length*ndst.w;
		}
	}

	string[] textSpliter(string text) {
		auto ret = appender!(string[])();

		double w = font.Size.w / 16  * scale;

		while (text.length) {
			long max = text.indexOf('\n');
			if (max != -1) {
				max = min(min(max, cast(int)(maxWidth/w) - 1), text.length - 1);
			} else {
				if (text.length < cast(int)(maxWidth/w))
					max = text.length - 1;
				else
					max = cast(int)(maxWidth/w) - 1;
			}
			long index = max;

			char c = text[index];
			while (c != ' ' && c != '\r' && c != '\n' && c != '\t' && index > 0)
				c = text[--index];

			if (index <= 0)
				index = max;

			string tmp = text[0 .. index + 1].replace("\r", " ").replace("\n", " ").replace("\t", " ");
			if (tmp[tmp.length-1] == ' ')
				tmp = tmp[0 .. $ - 1];
			ret.put(tmp);
			text = text[index + 1 .. $];
		}

		return ret.data;
	}
}

