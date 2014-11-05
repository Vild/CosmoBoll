module space.graphics.texture;

import std.string : toStringz;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import space.log.log;
import space.utils.renderhelper;
import space.utils.mathhelper;

class Texture {
public:
	this(SDL_Renderer* renderer, RenderHelper* renderHelper, string file) {
		this.renderer = renderer;
		this.renderHelper = renderHelper;
		loadFile(file);
	}

	~this() {
		SDL_DestroyTexture(texture);
	}

	void Render(SDL_Rectd* src, SDL_Rectd* dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		SDL_Rect nsrc = (src is null) ? size.Rect() : src.Rect();
		SDL_Rect ndst = dst.Rect();
		Log.MainLogger.Info!Render("src %f,\t%f,\t%f,\t%f", dst.x, dst.y, dst.w, dst.h);
		Log.MainLogger.Info!Render("nsrc %d,\t%d,\t%d,\t%d", ndst.x, ndst.y, ndst.w, ndst.h);
		if (renderHelper !is null && correction) {
			SDL_Pointd mid = renderHelper.Middle;
			double scale = renderHelper.Scale;
			ndst = SDL_Rectd((dst.x + mid.x)*scale, (dst.y + mid.y)*scale, dst.w*scale, dst.h*scale).Rect();
			SDL_Log("test");
		}
		SDL_RenderCopyEx(renderer, texture, &nsrc, &ndst, angle, null, flip);
	}

	@property SDL_Texture* Texture() { return texture; }
	@property SDL_Rectd* Size() { return size; }
	void SetAlpha(ubyte a) {
		SDL_SetTextureAlphaMod(texture, a);
	}
	void SetAlpha(double a) {
		SetAlpha(cast(ubyte)(255*a));
	}
	void SetColor(ubyte r, ubyte g, ubyte b) {
		SDL_SetTextureColorMod(texture, r, g, b);
	}
protected:
	SDL_Renderer* renderer;
	RenderHelper* renderHelper;
	this(SDL_Renderer* renderer, RenderHelper* renderHelper) {
		this.renderer = renderer;
		this.renderHelper = renderHelper;
	}

private:
	SDL_Texture *texture;
	SDL_Rectd *size;

	void loadFile(string file) {
		texture = IMG_LoadTexture(renderer, file.toStringz);
		if (texture is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);
		else
			Log.MainLogger.Info!loadFile("Loaded texture '%s'", file);

		int w, h;
		SDL_QueryTexture(texture, null, null, &w, &h);
		size = new SDL_Rectd(0.0, 0.0, w, h);
	}
}

class BlockTexture : Texture { //TODO: Remove/Change?, i'm too lazy now
public:
	this(SDL_Renderer* renderer, RenderHelper* renderHelper, SDL_Color color) {
		super(renderer, renderHelper);
		this.color = color;
	}

	override void Render(SDL_Rectd* src, SDL_Rectd* dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		SDL_Pointd mid = renderHelper.Middle;
		double scale = renderHelper.Scale;
		SDL_Rect ndst = (renderHelper !is null && correction) ? SDL_Rectd((dst.x + mid.x)*scale, (dst.y + mid.y)*scale, dst.w*scale, dst.h*scale).Rect() : dst.Rect();
		SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
		SDL_RenderFillRect(renderer, &ndst);
	}

private:
	SDL_Color color;
}
