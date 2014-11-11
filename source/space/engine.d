module space.engine;
import derelict.sdl2.image;
import derelict.sdl2.mixer;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import space.enginestate;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.music.song;
import space.utils.mathhelper;
import std.conv : to;
import std.datetime;
import std.string : toStringz;

class Engine {
public:
	this(string title, int width, int height, bool fullscreen) {
		log = Log.MainLogger;
		state = null;
		newstate = null;
		loadLibraries();
		this.size = SDL_Pointd(width, height);
		this.sizerect = SDL_Rectd(0, 0, width, height);
		initSDL(title, width, height, fullscreen);
		keyboard = new Keyboard();
		mouse = new Mouse();
		this.fpslock = false;
	}

	~this() {
		destroy(mouse);
		destroy(keyboard);
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
				} else if (event.type == SDL_WINDOWEVENT) {
					if (event.window.event == SDL_WINDOWEVENT_FOCUS_LOST) {
						fpslock = true;
						log.Info!Renderer("Locked");
					} else if (event.window.event == SDL_WINDOWEVENT_FOCUS_GAINED) {
						fpslock = false;
						log.Info!Renderer("Unlocked");
					}
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
			if (fpslock)
				SDL_Delay(1000/30); //Lock to 10 fps
		}

	}

	@property SDL_Renderer* Renderer() { return renderer; }
	@property EngineState State() { return state; }
	void ChangeState(T, Args...)(Args args) {
		//TODO: implement loading image
		static assert(__traits(compiles, new T(args)));
		this.newstate = new T(args);
	}
	@property void Quit() {
		this.newstate = null;
	}
	@property double CurrentTick() { return tick; }
	@property int FPS() { return currentFPS; }
	@property double FPS_MS() { return currentFPS_MS; }
	@property Mouse MouseState() { return mouse; };
	@property Keyboard KeyboardState() { return keyboard; }

	@property ref SDL_Pointd Size() { return size; }
	@property ref SDL_Rectd SizeRect() { return sizerect; }
private:
	Log log;

	SDL_Window* window;
	SDL_Renderer* renderer;
	EngineState state;
	EngineState newstate;
	Mouse mouse;
	Keyboard keyboard;
	bool fpslock;

	SDL_Pointd size;
	SDL_Rectd sizerect;

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
		SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
		SDL_DisableScreenSaver();

		if ((IMG_Init(IMG_INIT_PNG)&IMG_INIT_PNG) != IMG_INIT_PNG)
			log.Critical!initSDL("IMG_Init(): %s", to!string(IMG_GetError));

		if ((Mix_Init(MIX_INIT_OGG)&MIX_INIT_OGG) != MIX_INIT_OGG)
			log.Critical!initSDL("IMG_Init(): %s", to!string(Mix_GetError));

		if (Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT, 2, 1024) != 0)
			log.Critical!initSDL("Mix_OpenAudio(): %s", to!string(Mix_GetError));

		SDL_Surface* icon = IMG_Load(toStringz("res/img/icon.png"));

		SDL_SetWindowIcon(window, icon);
		SDL_FreeSurface(icon);
	}
}

