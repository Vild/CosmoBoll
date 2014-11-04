module space.graphics.texture;

import std.string : toStringz;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import space.log.log;

class Texture {
public:
	this(SDL_Renderer* renderer, string file) {
		this.renderer = renderer;
		loadFile(file);
	}

	~this() {
		SDL_DestroyTexture(texture);
	}

	void Render(SDL_Rect* src, SDL_Rect* dst, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		SDL_RenderCopyEx(renderer, texture, (src is null) ? size : src, dst, angle, null, flip);
	}

	@property SDL_Texture* Texture() { return texture; }
	@property SDL_Rect* Size() { return size; }
	void SetAlpha(ubyte a) {
		SDL_SetTextureAlphaMod(texture, a);
	}
	void SetAlpha(double a) {
		SetAlpha(cast(ubyte)(255*a));
	}
	void SetColor(ubyte r, ubyte g, ubyte b) {
		SDL_SetTextureColorMod(texture, r, g, b);
	}

private:
	SDL_Renderer *renderer;
	SDL_Texture *texture;
	SDL_Rect *size;

	void loadFile(string file) {
		texture = IMG_LoadTexture(renderer, file.toStringz);
		if (texture is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);
		else
			Log.MainLogger.Info!loadFile("Loaded texture '%s'", file);

		int w, h;
		SDL_QueryTexture(texture, null, null, &w, &h);
		size = new SDL_Rect(0, 0, w, h);
	}
}

