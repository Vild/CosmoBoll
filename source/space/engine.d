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

class Engine {
public:
	this() {
		log = Log.MainLogger;
		loadLibraries();
		initSDL("Codename Space - Lorem Ipsum", 1366, 768, false);
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
		Texture tex = new Texture(renderer, "res/img/64x64.png");
		Song song = new Song("res/song/song.ogg");
		Song success = new Song("res/song/success.ogg");
		Song laugh = new Song("res/song/laugh.ogg");
		SDL_Rect* middle = new SDL_Rect((1366/2)-(tex.Size.w/2*2), (768/2)-(tex.Size.h/2*2), tex.Size.w*2, tex.Size.h*2);
		Text fpstext = new Text(renderer, "FPS: UNKNOWN", 2);
		double count = 0;
		bool lock = false;
		TickDuration oldtime = Clock.currAppTick;

		lastTime = SDL_GetTicks();
		frame = 0;
		tick = 0;


		while (!done) {
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
					else if (event.key.keysym.sym == SDLK_a	)
						song.Play(1);
					else if (event.key.keysym.sym == SDLK_s)
						lock = !lock;
				}
			}

			SDL_SetRenderDrawColor(renderer, 0, 255, 255, 255);
			SDL_RenderClear(renderer);
			tex.Render(null, middle, count);
			fpstext.Render(new SDL_Rect(10, 10));
			SDL_RenderPresent(renderer);
			count += delta*2;
			frame++;
			tick+=delta;
			if (SDL_GetTicks() - lastTime >= 1000) {
				import std.string : format;
				string f = format("%d fps, %f ms/frame", frame, 1000.0/cast(double)frame);
				log.Info!MainLoop(f);
				fpstext.Text = f;
				frame = 0;
				lastTime += 1000;
			}
			if (lock)
				SDL_Delay(1000/60);
		}

	}
private:
	Log log;

	SDL_Window* window;
	SDL_Renderer* renderer;

	uint lastTime;
	int frame;
	
	double tick;

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

