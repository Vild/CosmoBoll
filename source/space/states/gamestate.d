module space.states.gamestate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.ball;
import space.graphics.forcefield;
import space.graphics.player;
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
import std.math;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		renderHelper = new RenderHelper(engine);
		bg = new ScrollingBackground(engine, "res/img/background.png");
		surface = new Texture(engine, &renderHelper, "res/img/surface.png");
		surfacePos = new SDL_Rectd(0, 768-surface.Size.h/10*7, 1366, surface.Size.h/10*7);
		platform = new Texture(engine, &renderHelper, "res/img/platform.png");
		platformsmall = new Texture(engine, &renderHelper, "res/img/platformsmall.png");
		//platformPos = SDL_Rectd((engine.Size.w / 2) - (366/2), engine.Size.h-90, 366, 90);
		platformPos1 = new AABB((engine.Size.w / 2) - (366/2), engine.Size.h-120, 366, 120);
		platformPos2 = new AABB((engine.Size.w / 4) - (300/2), engine.Size.h/2-50, 300, 50);
		platformPos3 = new AABB((engine.Size.w / 4)*3 - (300/2), engine.Size.h/2-50, 300, 50);
		platformPole = new Texture(engine, &renderHelper, "res/img/pole.png");
		platformPole1 = SDL_Rectd((engine.Size.w / 4) - (300/2)+22+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);
		platformPole2 = SDL_Rectd((engine.Size.w / 4) - (300/2)+300/2-23+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);
		platformPole3 = SDL_Rectd((engine.Size.w / 4) - (300/2)+300-66+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);
		platformPole4 = SDL_Rectd((engine.Size.w / 4)*3 - (300/2)+22+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);
		platformPole5 = SDL_Rectd((engine.Size.w / 4)*3 - (300/2)+300/2-23+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);
		platformPole6 = SDL_Rectd((engine.Size.w / 4)*3 - (300/2)+300-66+8, engine.Size.h/2-8, 26, engine.Size.h/2+8);

		sides = new BlockTexture(engine, &renderHelper, SDL_Color(0, 0, 0, 0));
		platformSide1 = new AABB(0, -132, 1, 900);
		platformSide2 = new AABB(1366-1, -132, 1, 900);
		platformTop = new AABB(0, -132, 1366, 1);
		forceField1 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(255, 200, 200), SDL_Color(161, 84, 60, 180), SDL_Rectd(0, 768-75, 1366/2, 75));
		forceField2 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(200, 200, 255), SDL_Color(60, 84, 161, 180), SDL_Rectd(1366/2, 768-75, 1366/2, 75));

		player1 = new Player(engine, SDL_Color(255, 200, 200), new AABB(1366/2-44/2-44, -73, 44, 73), SDL_SCANCODE_W, SDL_SCANCODE_S, SDL_SCANCODE_A, SDL_SCANCODE_D, SDL_SCANCODE_SPACE);
		player2 = new Player(engine, SDL_Color(200, 200, 255), new AABB(1366/2-44/2+44, -73, 44, 73), SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT, SDL_SCANCODE_RIGHT, SDL_SCANCODE_RSHIFT);
		player2.LookLeft = true;

		ball = new Ball(engine, new Texture(engine, &renderHelper, "res/img/ball.png"),new AABB(1366/2-40/2, -100, 40, 40), [
			SDL_Pointd((engine.Size.w / 4), engine.Size.h/2-100),
			SDL_Pointd((engine.Size.w / 4)*3, engine.Size.h/2-100),
			SDL_Pointd((engine.Size.w / 2), engine.Size.h-200)
		]);
		fpstext = new Text(engine, "FPS: UNKNOWN", 2);


		point1 = 0;
		point2 = 0;
		pointText1 = new Text(engine, format("%d", point1), 8);
		pointText2 = new Text(engine, format("%d", point2), 8);

		pointText1.SetColor(255, 100, 100);
		pointText2.SetColor(100, 100, 255);

		time = 60*2;
		timeText = new Text(engine, format("%d", cast(int)time.round), 8);
	}
	
	~this() {
		destroy(timeText);
		destroy(pointText2);
		destroy(pointText1);
		destroy(fpstext);
		destroy(ball);
		destroy(player2);
		destroy(player1);
		destroy(forceField2);
		destroy(forceField1);
		destroy(platformTop);
		destroy(platformSide2);
		destroy(platformSide1);
		destroy(sides);
		destroy(platformPole6);
		destroy(platformPole5);
		destroy(platformPole4);
		destroy(platformPole3);
		destroy(platformPole2);
		destroy(platformPole1);
		destroy(platformPole);
		destroy(platformPos3);
		destroy(platformPos2);
		destroy(platformPos1);
		destroy(platformsmall);
		destroy(platform);
		destroy(surface);
		destroy(bg);
		destroy(renderHelper);
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
			if (ball.Pos.X > engine.Size.x/2)
				point1++;
			else
				point2++;
			ball.Respawn();
		}

		bg.Update(delta);
		forceField1.Update(delta);
		forceField2.Update(delta);

		time -= delta;

		//renderHelper.Update(playerPos1, playerPos2); //Todo: change
		fpstext.Text = format("%d fps, %f ms/frame", engine.FPS, engine.FPS_MS);
		pointText1.Text = format("%d", point1);
		pointText2.Text = format("%d", point2);
		timeText.Text = format("%d", cast(int)time.round);

		pointTextPos1 = SDL_Rectd(20, 20, 0, 0);
		pointTextPos2 = SDL_Rectd(engine.Size.w-20-pointText2.Size.w, 20, 0, 0);
		timeTextPos = SDL_Rectd(engine.Size.w/2-timeText.Size.w/2, 20, 0, 0);
	}
	override void Render() {
		bg.Render();
		surface.Render(null, &surfacePos, false);
		platformPole.Render(null, &platformPole1, false);
		platformPole.Render(null, &platformPole2, false);
		platformPole.Render(null, &platformPole3, false);
		platformPole.Render(null, &platformPole4, false);
		platformPole.Render(null, &platformPole5, false);
		platformPole.Render(null, &platformPole6, false);

		player1.Render();
		player2.Render();
		ball.Render();

		forceField1.Render();
		forceField2.Render();

		platform.Render(null, &platformPos1.Rect(), false);
		platformsmall.Render(null, &platformPos2.Rect(), false);
		platformsmall.Render(null, &platformPos3.Rect(), false);
		sides.Render(null, &platformSide1.Rect(), false);
		sides.Render(null, &platformSide2.Rect(), false);
		sides.Render(null, &platformTop.Rect(), false);
	
		SDL_Rectd tmppos = SDL_Rectd(10, 50, 0, 0);
		fpstext.Render(&tmppos);

		pointText1.SetColor(200, 100, 100, 100);
		pointTextPos1.x += 8;
		pointTextPos1.y -= 8;
		pointText1.Render(&pointTextPos1);
		pointText1.SetColor(255, 100, 100, 255);
		pointTextPos1.x -= 8;
		pointTextPos1.y += 8;
		pointText1.Render(&pointTextPos1);

		pointText2.SetColor(100, 100, 200, 100);
		pointTextPos1.x += 8;
		pointTextPos1.y -= 8;
		pointText2.Render(&pointTextPos2);
		pointText2.SetColor(100, 100, 255, 255);
		pointTextPos2.x -= 8;
		pointTextPos2.y += 8;
		pointText2.Render(&pointTextPos2);

		timeText.SetColor(200, 200, 200, 100);
		timeTextPos.x += 8;
		timeTextPos.y -= 8;
		timeText.Render(&timeTextPos);
		timeText.SetColor(255, 255, 255, 255);
		timeTextPos.x -= 8;
		timeTextPos.y += 8;
		timeText.Render(&timeTextPos);

	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture surface;
	SDL_Rectd surfacePos;
	Texture platform;
	Texture platformsmall;
	AABB platformPos1;
	AABB platformPos2;
	AABB platformPos3;
	Texture platformPole;
	SDL_Rectd platformPole1;
	SDL_Rectd platformPole2;
	SDL_Rectd platformPole3;
	SDL_Rectd platformPole4;
	SDL_Rectd platformPole5;
	SDL_Rectd platformPole6;
	Texture sides;
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
	Text pointText1;
	Text pointText2;
	SDL_Rectd pointTextPos1;
	SDL_Rectd pointTextPos2;
	double time;
	Text timeText;
	SDL_Rectd timeTextPos;
}
