module space.io.mouse;

import derelict.sdl2.sdl;
import space.log.log;
import space.engine;

class Mouse {
public:
	this() {
		this.engine = null;
	}
	
	void SetEngine(Engine* engine) {
		this.engine = engine;
	}
	
	void Update() {
		int state = SDL_GetMouseState(&this.x, &this.y);
		if (engine !is null) {
			int w = x, h = y;
			SDL_GetWindowSize(engine.Window, &w, &h);
			this.x = cast(int)(this.x*engine.Size.x/w);
			this.y = cast(int)(this.y*engine.Size.y/h);
		}
		bool left = !!(state & SDL_BUTTON(SDL_BUTTON_LEFT));
		this.justClicked = left && !this.left;
		if (this.justClicked)
			SDL_Log("x: %d, y: %d", x, y);
		this.left = left;
	}

	@property int X() { return x; }
	@property int Y() { return y; }
	@property bool Left() { return left; }
	@property bool JustClicked() { return justClicked; }
private:
	Engine* engine;
	int x = 0;
	int y = 0;
	bool left = false;
	bool justClicked = false;
}

