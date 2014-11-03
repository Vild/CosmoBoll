module space.engine;
import std.string : toStringz;
import std.conv : to;
import std.datetime;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.mixer;
import derelict.sdl2.ttf;

import space.graphics.texture;
import space.music.song;
import space.graphics.text;
import space.log.log;
import space.enginestate;
import space.io.keyboard;
import space.io.mouse;

class Engine {
public:
	this(string title, int width, int height, bool fullscreen) {
		log = Log.MainLogger;
		state = null;
		newstate = null;
		loadLibraries();
		this.size = SDL_Rect(0, 0, width, height);
		initSDL(title, width, height, fullscreen);
		keyboard = new Keyboard();
		mouse = new Mouse();
	}

	~this() {
		Mix_CloseAudio();
		Mix_Quit();
		IMG_Quit();
		SDL_Quit();
	}

	void MainLoop() {
		bool done = false;
		SDL_Event event;
		TickDuration oldtime = Clock.currAppTick;

		lastTime = SDL_GetTicks();
		frame = 0;
		tick = 0;


		while (!done) {
			if (state != newstate) {
				destroy(state);
				state = newstate;
			}

			if (state is null)
				break;

			TickDuration curtime = Clock.currAppTick;
			TickDuration diff = curtime - oldtime;
			double delta = cast(double)diff.usecs/1_000_000;//1 000 000 µsec/ 1 sec
			if (delta != 0)
				oldtime = curtime;

			while(SDL_PollEvent(&event)) {
				if (event.type == SDL_QUIT)
					done = true;
				else if (event.type == SDL_KEYDOWN) {
					if (event.key.keysym.sym == SDLK_ESCAPE)
						done = true;
				}
			}

			keyboard.Update(delta);
			mouse.Update();

			state.Update(delta);

			SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
			SDL_RenderClear(renderer);
			state.Render();

			SDL_RenderPresent(renderer);
			frame++;
			tick+=delta;
			if (SDL_GetTicks() - lastTime >= 1000) {
				import std.string : format;
				currentFPS = frame;
				currentFPS_MS = 1000.0/cast(double)frame;
				frame = 0;
				lastTime += 1000;
			}
		}

	}

	@property SDL_Renderer* Renderer() { return renderer; }
	@property EngineState State() { return state; }
	@property EngineState State(EngineState state) {
		this.newstate = state;
		return state;
	}
	@property double CurrentTick() { return tick; }
	@property int FPS() { return currentFPS; }
	@property double FPS_MS() { return currentFPS_MS; }
	@property Mouse MouseState() { return mouse; };
	@property Keyboard KeyboardState() { return keyboard; }

	@property ref SDL_Rect Size() { return size; }
private:
	Log log;

	SDL_Window* window;
	SDL_Renderer* renderer;
	EngineState state;
	EngineState newstate;
	Mouse mouse;
	Keyboard keyboard;


	SDL_Rect size;

	uint lastTime;
	int frame;
	double tick;
	int currentFPS;
	double currentFPS_MS;

	void loadLibraries() {
		DerelictSDL2.load();
		DerelictSDL2Image.load();
		DerelictSDL2Mixer.load();
		DerelictSDL2ttf.load();
	}
	
	void initSDL(string title, int width, int height, bool fullscreen) {
		if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
			log.Critical!initSDL("SDL_Init(): %s", to!string(SDL_GetError));

		window = SDL_CreateWindow(toStringz(title), SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, (fullscreen) ? SDL_WINDOW_FULLSCREEN : 0);
		if (window is null)
			log.Critical!initSDL("SDL_CreateWindow(): %s", to!string(SDL_GetError));

		renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
		if (renderer is null)
			log.Critical!initSDL("SDL_CreateRenderer(): %s", to!string(SDL_GetError));
		SDL_DisableScreenSaver();

		if ((IMG_Init(IMG_INIT_PNG)&IMG_INIT_PNG) != IMG_INIT_PNG)
			log.Critical!initSDL("IMG_Init(): %s", to!string(IMG_GetError));

		if ((Mix_Init(MIX_INIT_OGG)&MIX_INIT_OGG) != MIX_INIT_OGG)
			log.Critical!initSDL("IMG_Init(): %s", to!string(Mix_GetError));

		if (Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 1024) != 0)
			log.Critical!initSDL("Mix_OpenAudio(): %s", to!string(Mix_GetError));
	}
}

