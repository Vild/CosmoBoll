module space.io.keyboard;

import derelict.sdl2.sdl;
class Keyboard {
public:
	this() {
		this.keystate = SDL_GetKeyboardState(&this.size);
		keyboardHold = new double[size];
		keyboardJustPressed = new bool[size];
		keyboardJustLetGo = new double[size];
	}

	~this() {
		destroy(keyboardJustLetGo);
		destroy(keyboardJustPressed);
		destroy(keyboardHold);
	}

	void Update(double delta) {
		for(int i = 0; i < size; i++) {
			if (keystate[i]) {
				keyboardJustLetGo[i] = 0;
				keyboardJustPressed[i] = (keyboardHold[i] == 0);
				keyboardHold[i] += delta;
			} else {
				keyboardJustLetGo[i] = keyboardHold[i];
				keyboardJustPressed[i] = false;
				keyboardHold[i] = 0;
			}
		}
	}

	double getHoldState(SDL_Scancode key) { return keyboardHold[key]; }
	double getJustLeftGo(SDL_Scancode key) { return keyboardJustLetGo[key]; }
	bool isDown(SDL_Scancode key) { return getHoldState(key) != 0; }
	bool isJustPressed(SDL_Scancode key) { return keyboardJustPressed[key]; }

private:
	double[] keyboardHold;
	bool[] keyboardJustPressed;
	double[] keyboardJustLetGo;
	Uint8* keystate;
	int size;
}

