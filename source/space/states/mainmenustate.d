module space.states.mainmenustate;


import space.engine;
import space.enginestate;
import space.graphics.texture;
import space.graphics.text;
import space.music.song;
import derelict.sdl2.sdl : SDL_Rect;

class MainMenuState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		tex = new Texture(engine.Renderer, "res/img/64x64.png");
		song = new Song("res/song/mainmenu.mp3");
		middle = SDL_Rect((1366/2)-(tex.Size.w/2*2), (768/2)-(tex.Size.h/2*2), tex.Size.w*2, tex.Size.h*2);
		fpstext = new Text(engine.Renderer, "FPS: UNKNOWN", 2);
	}
	
	~this() {
		destroy(fpstext);
		destroy(song);
		destroy(tex);
	}
	override void Update(double delta) {
		import std.string : format;
		count += delta*2;
		fpstext.Text = format("%d fps, %f ms/frame", engine.FPS, engine.FPS_MS);
	}
	override void Render() {
		tex.Render(null, &middle, count);
		fpstext.Render(new SDL_Rect(10, 10));
	}
	
private:
	double count = 0;
	Texture tex;
	Song song;
	SDL_Rect middle;
	Text fpstext;
}