module space.states.gamestate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.states.mainmenustate;
import space.utils.mathhelper;
import space.utils.renderhelper;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		renderHelper = new RenderHelper();
		bg = new ScrollingBackground(engine, "res/img/background.png");
		platform = new Texture(engine.Renderer, &renderHelper, "res/img/mainmenu_button.png"); //TODO: fix own texture
		platformPos = SDL_Rectd(cast(int)((engine.Size.w / 2) - 366/2), engine.Size.h-90, 366, 90);
		forceField = new BlockTexture(engine.Renderer, &renderHelper, SDL_Color(255, 0, 255, 255));
		forceField1 = SDL_Rectd(0, 768-60, 500, 60);
		forceField2 = SDL_Rectd(1366-500, 768-60, 500, 60);
		player = new BlockTexture(engine.Renderer, &renderHelper, SDL_Color(255, 0, 0, 255));
		playerPos = SDL_Rectd(1366/2-10/2, 768-90-20, 10, 20);
	}
	
	~this() {
		destroy(platform);
		destroy(bg);
	}

	override void Update(double delta) {
		bg.Update(delta);
		renderHelper.Update(playerPos, playerPos); //Todo: change

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || k.isDown(SDL_SCANCODE_SPACE) || k.isDown(SDL_SCANCODE_RETURN))
			engine.ChangeState!MainMenuState(engine);
			//engine.State = new MainMenuState(engine);


	}
	override void Render() {
		bg.Render();
		platform.Render(null, &platformPos);

		forceField.Render(null, &forceField1);
		forceField.Render(null, &forceField2);

		player.Render(null, &playerPos);
	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture platform;
	SDL_Rectd platformPos;
	Texture forceField;
	SDL_Rectd forceField1;
	SDL_Rectd forceField2;
	Texture player;
	SDL_Rectd playerPos;
}

