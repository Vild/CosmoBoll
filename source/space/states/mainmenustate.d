module space.states.mainmenustate;

import dtext;
import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.music.song;
import space.states.gamestate;
import space.states.tutorialstate;
import space.states.afkstate;
import space.states.creditsstate;
import space.utils.mathhelper;

class MainMenuState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		if ((allTheTime !is null && allTheTime.Current != "res/song/mainmenu.mp3") || allTheTime is null) {
			allTheTime = new Song("res/song/mainmenu.mp3", true);
			allTheTime.Play(-1);
		}
		bg = new ScrollingBackground(engine);
		title = new Texture(engine, null, "res/img/title.png");
		titlePos = SDL_Rectd((engine.Size.w/2)-(1815/6), 10, 1815/3, 1004/3);

		SDL_Rectd pos = SDL_Rectd((engine.Size.w/2)-(450/2), 0, 450, 120);
		pos.y += pos.h + 250;
		addButton(0, pos, _("Play"), 8, &onClick);
		pos.y += pos.h + 25;
		addButton(1, pos, _("Guide"), 8, &onClick);
		pos.y += pos.h + 25;
		addButton(2, pos, _("Credits"), 8, &onClick);
		pos.y += pos.h + 25;
		addButton(3, pos, _("Quit"), 8, &onClick);
	}
	
	~this() {
		destroy(buttons);
		destroy(title);
		destroy(bg);
	}

	override void Update(double delta) {
		import std.string : format;

		bg.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked) {
			import space.utils.mathhelper;
			foreach(ref Button b; buttons)
				if (MathHelper.CheckCollision(b.hitbox, SDL_Rectd(m.X, m.Y, 1, 1)))
					b.onClick(b);
		}
		if (k.isDown(SDL_SCANCODE_PAUSE))
			engine.ChangeState!AFKState(engine);
	}
	override void Render() {
		bg.Render();
		title.Render(null, &titlePos);
		foreach (Button b; buttons)
			b.text.Render(&b.textPos);
	}

	void onClick(ref Button button) {
		Log.MainLogger.Info!onClick("ID: %d was clicked", button.id);
		if (button.id == 0)
			engine.ChangeState!GameState(engine);
		else if (button.id == 1)
			engine.ChangeState!TutorialState(engine);
		else if (button.id == 2)
			engine.ChangeState!CreditsState(engine);
		else if (button.id == 3)
			engine.Quit();
	}

private:
	ScrollingBackground bg;
	//Text title;
	Texture title;
	SDL_Rectd titlePos;

	Button[] buttons;

	alias onClick_f = void delegate(ref Button button);

	static struct Button {
		int id;
		SDL_Rectd hitbox;
		Text text;
		SDL_Rectd textPos;
		onClick_f onClick;
	}

	void addButton(int id, SDL_Rectd pos, string str, double size, onClick_f onClick) {
		SDL_Rectd textPos;
		Text text = new Text(engine, str, size);
		textPos.x = pos.x + (pos.w/2) - (text.Size.w/2);
		textPos.y = pos.y + (pos.h/2) - (text.Size.h/2);
		textPos.w = 0;
		textPos.h = 0;
		text.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));

		buttons ~= Button(id, pos, text, textPos, onClick);
	}
}