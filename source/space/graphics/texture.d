module space.graphics.texture;

import derelict.sdl2.image;
import derelict.sdl2.sdl;
import space.engine;
import space.log.log;
import space.utils.mathhelper;
import space.utils.renderhelper;
import std.string : toStringz;
import space.physics.aabb;

class Texture {
public:
	this(Engine* engine, RenderHelper* renderHelper, string file) {
		this.renderer = engine.Renderer;
		this.renderHelper = renderHelper;
		loadFile(file);
		ORIGO_POSITION = SDL_Pointd(0, 0); //engine.Size/2;
	}

	~this() {
		SDL_DestroyTexture(texture);
	}

	void Render(ref SDL_Rectd src, ref SDL_Rectd dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		Render(&src, &dst, correction, angle, flip);
	}

	void Render(SDL_Rectd* src, SDL_Rectd* dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		SDL_Rect nsrc = (src is null) ? size.Rect() : src.Rect();
		SDL_Rect ndst = dst.Rect();
		if (renderHelper !is null && correction) {
			SDL_Pointd mid = renderHelper.PositionDiff;
			double scale = renderHelper.Scale;
			ndst = SDL_Rectd(((dst.x+ORIGO_POSITION.x)*scale) - mid.x, ((dst.y+ORIGO_POSITION.y)*scale) - mid.y, dst.w*scale, dst.h*scale).Rect();
		}
		SDL_RenderCopyEx(renderer, texture, &nsrc, &ndst, angle, null, flip);
	}

	@property SDL_Texture* Texture() { return texture; }
	@property SDL_Rectd Size() { return size; }
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
	SDL_Pointd ORIGO_POSITION;
	this(Engine* engine, RenderHelper* renderHelper) {
		this.renderer = engine.Renderer;
		this.renderHelper = renderHelper;
		ORIGO_POSITION = SDL_Pointd(0, 0);//engine.Size/2;
	}

private:
	SDL_Texture *texture;
	SDL_Rectd size;

	void loadFile(string file) {
		texture = IMG_LoadTexture(renderer, file.toStringz);
		if (texture is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);

		int w, h;
		SDL_QueryTexture(texture, null, null, &w, &h);
		size = SDL_Rectd(0.0, 0.0, w, h);

		Log.MainLogger.Info!loadFile("Loaded texture '%s' with size %dx%d", file, w, h);
	}
}

class BlockTexture : Texture { //TODO: Remove/Change?, i'm too lazy now
public:
	this(Engine* engine, RenderHelper* renderHelper, SDL_Color color) {
		super(engine, renderHelper);
		this.color = color;
	}

	override void Render(SDL_Rectd* src, SDL_Rectd* dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		SDL_Pointd mid = renderHelper.PositionDiff;
		double scale = renderHelper.Scale;
		SDL_Rect ndst = (renderHelper !is null && correction) ? SDL_Rectd(((dst.x+ORIGO_POSITION.x)*scale) - mid.x, ((dst.y+ORIGO_POSITION.y)*scale) - mid.y, dst.w*scale, dst.h*scale).Rect() : dst.Rect();
		SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
		SDL_RenderFillRect(renderer, &ndst);
	}

private:
	SDL_Color color;
}
