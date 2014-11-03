module space.states.mainmenustate;

import space.log.log;
import space.engine;
import space.enginestate;
import space.graphics.texture;
import space.graphics.text;
import space.music.song;
import space.io.mouse;
import derelict.sdl2.sdl;

class MainMenuState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		song = new Song("res/song/mainmenu.mp3");
		bg = new Texture(engine.Renderer, "res/img/mainmenubackground.png");
		title = new Text(engine.Renderer, "Cosmo Boll", 10);
		titlePos = SDL_Rect((engine.Size.w/2)-cast(int)(title.Text.length*title.Scale*8/2), 50, cast(int)(title.Text.length*title.Scale*8), cast(int)(title.Scale*8));
		buttonTex = new Texture(engine.Renderer, "res/img/mainmenu_button.png");

		SDL_Rect middle_button = SDL_Rect((engine.Size.w/2)-(buttonTex.Size.w/2), 0/*placeholder*/, buttonTex.Size.w, buttonTex.Size.h);
		middle_button.y += middle_button.h + 200;
		buttons ~= Button(0, middle_button, new Text(engine.Renderer, "Play", 10), middle_button, &onClick);
		middle_button.y += middle_button.h + 50;
		buttons ~= Button(1, middle_button, new Text(engine.Renderer, "Quit", 10), middle_button, &onClick);
		middle_button.y += middle_button.h + 50;
	}
	
	~this() {
		destroy(buttonTex);
		destroy(title);
		destroy(bg);
		destroy(song);
	}
	override void Update(double delta) {
		import std.string : format;
		//count += delta*8;

		Mouse m = engine.MouseState;
		if (m.JustClicked) {
			import space.utils.mathhelper;
			foreach(ref Button b; buttons)
				if (MathHelper.CheckCollision(b.hitbox, SDL_Rect(m.X, m.Y, 1, 1)))
					b.onClick(b);
		}

	}
	override void Render() {
		bg.Render(null, &engine.Size());
		title.Render(&titlePos);
		foreach (Button b; buttons) {
			buttonTex.Render(null, &b.hitbox);
			b.text.Render(&b.textPos);
		}
	}

	void onClick(ref Button button) {
		Log.MainLogger.Info!onClick("ID: %d was clicked", button.id);
		if (button.id == 1)
			engine.State = null;
	}

private:
	Song song;
	Texture bg;
	Text title;
	SDL_Rect titlePos;

	Texture buttonTex;
	Button[] buttons;

	static struct Button {
		int id;
		SDL_Rect hitbox;
		Text text;
		SDL_Rect textPos;
		void delegate(ref Button button) onClick;
	}
}