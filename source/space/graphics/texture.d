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
		this.texture = loadFile(file);
		ORIGO_POSITION = SDL_Pointd(0, 0); //engine.Size/2;
	}

	~this() {
		SDL_DestroyTexture(texture);
	}

	void Update(double delta) {
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

	SDL_Texture* loadFile(string file) {
		SDL_Texture* texture = IMG_LoadTexture(renderer, file.toStringz);
		if (texture is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);

		int w, h;
		SDL_QueryTexture(texture, null, null, &w, &h);
		size = SDL_Rectd(0.0, 0.0, w, h);

		Log.MainLogger.Info!loadFile("Loaded texture '%s' with size %dx%d", file, w, h);
		return texture;
	}
}

class BlockTexture : Texture {
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

class AnimatedTexture : Texture {
public:
	this(Engine* engine, RenderHelper* renderHelper, string[] frames, double delay) {
		super(engine, renderHelper);
		textures = new SDL_Texture*[frames.length];
		for(int i = 0; i < frames.length; i++)
			textures[i] = loadFile(frames[i]);
		this.delay = delay;
		this.count = 0;
	}

	~this() {
		foreach(tex; textures)
			SDL_DestroyTexture(tex);
		destroy(textures);
	}

	override void Update(double delta) {
		count += delta;
	}

	override void Render(SDL_Rectd* src, SDL_Rectd* dst, bool correction = true, double angle = 0.0, SDL_RendererFlip flip = SDL_FLIP_NONE) {
		int frame = cast(int)((cast(int)(count / delay))%textures.length);
		SDL_Texture* tex = textures[frame];

		SDL_Rect nsrc = (src is null) ? size.Rect() : src.Rect();
		SDL_Rect ndst = dst.Rect();
		if (renderHelper !is null && correction) {
			SDL_Pointd mid = renderHelper.PositionDiff;
			double scale = renderHelper.Scale;
			ndst = SDL_Rectd(((dst.x+ORIGO_POSITION.x)*scale) - mid.x, ((dst.y+ORIGO_POSITION.y)*scale) - mid.y, dst.w*scale, dst.h*scale).Rect();
		}
		SDL_RenderCopyEx(renderer, tex, &nsrc, &ndst, angle, null, flip);
	}

	override void SetAlpha(ubyte a) {
		foreach(texture; textures)
			SDL_SetTextureAlphaMod(texture, a);
	}
	override void SetAlpha(double a) {
		SetAlpha(cast(ubyte)(255*a));
	}
	override void SetColor(ubyte r, ubyte g, ubyte b) {
		foreach(texture; textures)
			SDL_SetTextureColorMod(texture, r, g, b);
	}

private:
	SDL_Texture*[] textures;
	double delay;
	double count;
}