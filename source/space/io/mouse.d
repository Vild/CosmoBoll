module space.io.mouse;

import derelict.sdl2.sdl;
import space.log.log;

class Mouse {
public:
	void Update() {
		int state = SDL_GetMouseState(&this.x, &this.y);
		bool left = !!(state & SDL_BUTTON(SDL_BUTTON_LEFT));
		this.justClicked = left && !this.left;
		this.left = left;
	}

	@property int X() { return x; }
	@property int Y() { return y; }
	@property bool Left() { return left; }
	@property bool JustClicked() { return justClicked; }
private:
	int x = 0;
	int y = 0;
	bool left = false;
	bool justClicked = false;
}

