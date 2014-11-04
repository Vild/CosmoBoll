module space.states.gamestate;

import space.engine;
import space.enginestate;
import space.graphics.texture;
import space.graphics.text;
import space.io.mouse;
import space.io.keyboard;
import space.utils.mathhelper;
import space.graphics.scrollingbackground;

import space.states.mainmenustate;

import derelict.sdl2.sdl;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		bg = new ScrollingBackground(engine, "res/img/background.png");
		platform = new Texture(engine.Renderer, "res/img/mainmenu_button.png"); //TODO: fix own texture
		platformPos = SDL_Rect(cast(int)((engine.Size.w / 2) - 366/2), engine.Size.h-90, 366, 90);
	}
	
	~this() {
		destroy(platform);
		destroy(bg);
	}

	override void Update(double delta) {
		bg.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || k.isDown(SDL_SCANCODE_SPACE) || k.isDown(SDL_SCANCODE_RETURN))
			engine.ChangeState!MainMenuState(engine);
			//engine.State = new MainMenuState(engine);


	}
	override void Render() {
		bg.Render();
		platform.Render(null, &platformPos);
		SDL_Rect pos = SDL_Rect(0, 768-60, 500, 60);
		SDL_SetRenderDrawColor(engine.Renderer, 255, 0, 0, 255);
		SDL_RenderFillRect(engine.Renderer, &pos);

		pos = SDL_Rect(1366-500, 768-60, 500, 60);
		SDL_SetRenderDrawColor(engine.Renderer, 255, 0, 0, 255);
		SDL_RenderFillRect(engine.Renderer, &pos);

		pos = SDL_Rect(1366/2-10/2, 768-90-20, 10, 20);
		SDL_SetRenderDrawColor(engine.Renderer, 255, 0, 0, 255);
		SDL_RenderFillRect(engine.Renderer, &pos);
	}

private:
	ScrollingBackground bg;
	Texture platform;
	SDL_Rect platformPos;

}

