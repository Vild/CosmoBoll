module space.io.keyboard;

import derelict.sdl2.sdl;
class Keyboard {
public:
	this() {
		this.keystate = SDL_GetKeyboardState(&this.size);
		keyboardHold = new double[size];
		keyboardJustPressed = new bool[size];
	}

	~this() {
		destroy(keyboardHold);
	}

	void Update(double delta) {
		for(int i = 0; i < size; i++) {
			if (keystate[i]) {
				keyboardJustPressed[i] = (keyboardHold[i] == 0);
				keyboardHold[i] += delta;
			} else
				keyboardHold[i] = 0;
		}
	}

	double getHoldState(SDL_Scancode key) {
		return keyboardHold[key];
	}
	bool isDown(SDL_Scancode key) { return getHoldState(key) != 0; };

	bool isJustPressed(SDL_Scancode key) {
		return keyboardJustPressed[key];
	}

private:
	double[] keyboardHold;
	bool[] keyboardJustPressed;
	Uint8* keystate;
	int size;
}

