module space.states.gamestate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.forcefield;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.physics.aabb;
import space.states.mainmenustate;
import space.utils.mathhelper;
import space.utils.renderhelper;
import space.graphics.player;
import space.graphics.ball;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		renderHelper = new RenderHelper(engine);
		bg = new ScrollingBackground(engine, "res/img/background.png");
		platform = new Texture(engine, &renderHelper, "res/img/platform.png");
		platformsmall = new Texture(engine, &renderHelper, "res/img/platformsmall.png");
		//platformPos = SDL_Rectd((engine.Size.w / 2) - (366/2), engine.Size.h-90, 366, 90);
		platformPos1 = new AABB((engine.Size.w / 2) - (366/2), engine.Size.h-120, 366, 120);
		platformPos2 = new AABB((engine.Size.w / 4) - (300/2), engine.Size.h/2-50, 300, 40);
		platformPos3 = new AABB((engine.Size.w / 4)*3 - (300/2), engine.Size.h/2-50, 300, 40);

		platformSide1 = new AABB(0, -132, 5, 900);
		platformSide2 = new AABB(1366-5, -132, 5, 900);
		platformTop = new AABB(0, -132, 1366, 5);
		forceField1 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(255, 200, 200), SDL_Color(161, 84, 60, 180), SDL_Rectd(0, 768-75, 1366/2, 75));
		forceField2 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(200, 200, 255), SDL_Color(60, 84, 161, 180), SDL_Rectd(1366/2, 768-75, 1366/2, 75));

		player1 = new Player(engine, SDL_Color(255, 200, 200), new AABB(1366/2-44/2-44, -73, 44, 73), SDL_SCANCODE_W, SDL_SCANCODE_S, SDL_SCANCODE_A, SDL_SCANCODE_D, SDL_SCANCODE_SPACE);
		player2 = new Player(engine, SDL_Color(200, 200, 255), new AABB(1366/2-44/2+44, -73, 44, 73), SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT, SDL_SCANCODE_RIGHT, SDL_SCANCODE_RSHIFT);
		player2.LookLeft = true;

		ball = new Ball(engine, new Texture(engine, &renderHelper, "res/img/ball.png"),new AABB(1366/2-40/2, -100, 40, 40), [
			SDL_Pointd((engine.Size.w / 4), engine.Size.h/2-100),
			SDL_Pointd((engine.Size.w / 4)*3, engine.Size.h/2-100)
		]);
		fpstext = new Text(engine, "FPS: UNKNOWN", 2);


		point1 = 0;
		point2 = 0;
		pointText = new Text(engine, "0 - 0", 2);
	}
	
	~this() {
		destroy(platform);
		destroy(bg);
	}

	override void Update(double delta) {
		double speed = 400;
		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;


		if (k.isDown(SDL_SCANCODE_RETURN))
		    engine.ChangeState!MainMenuState(engine);

		AABB[] hitthingy = [platformPos1, platformPos2, platformPos3,
			platformSide1, platformSide2, platformTop,
			forceField1.R1, forceField1.R2, forceField2.R1, forceField2.R2];

		player1.Update(delta, speed, delta*speed/8, hitthingy, &ball);
		player2.Update(delta, speed, delta*speed/8, hitthingy, &ball);

		ball.Update(delta, speed, delta*speed/8.5, hitthingy);

		if (player1.Pos.Y > engine.Size.y) player1.Respawn();
		if (player2.Pos.Y > engine.Size.y) player2.Respawn();
		if (ball.Pos.Y > engine.Size.y) {
			if (ball.Pos.X < engine.Size.x/2)
				point1++;
			else
				point2++;
			ball.Respawn();
		}

		bg.Update(delta);
		forceField1.Update(delta);
		forceField2.Update(delta);
		//renderHelper.Update(playerPos1, playerPos2); //Todo: change
		fpstext.Text = format("%d fps, %f ms/frame", engine.FPS, engine.FPS_MS);
		pointText.Text = format("%-3d - %3d", point1, point2);
	}
	override void Render() {
		bg.Render();

		player1.Render();
		player2.Render();
		ball.Render();

		forceField1.Render();
		forceField2.Render();

		platform.Render(null, &platformPos1.Rect(), false);
		platformsmall.Render(null, &platformPos2.Rect(), false);
		platformsmall.Render(null, &platformPos3.Rect(), false);
		platform.Render(null, &platformSide1.Rect(), false);
		platform.Render(null, &platformSide2.Rect(), false);
		platform.Render(null, &platformTop.Rect(), false);

		SDL_Rectd tmppos = SDL_Rectd(10, 10, 0, 0);
		fpstext.Render(&tmppos);
		tmppos.x = (engine.Size.x/2) - (pointText.Size.w/2);
		pointText.Render(&tmppos);
	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture platform;
	Texture platformsmall;
	AABB platformPos1;
	AABB platformPos2;
	AABB platformPos3;
	AABB platformSide1;
	AABB platformSide2;
	AABB platformTop;
	ForceField forceField1;
	ForceField forceField2;
	Player player1;
	Player player2;
	Ball ball;
	Text fpstext;
	int point1;
	int point2;
	Text pointText;
}
