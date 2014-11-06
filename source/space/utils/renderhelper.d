module space.utils.renderhelper;

import derelict.sdl2.sdl;
import space.utils.mathhelper;
import std.algorithm;
import space.log.log;
import space.engine;

class RenderHelper {
public:
	this(Engine* engine) {
		this.engine = engine;
	}

	void Update(SDL_Rectd p1, SDL_Rectd p2) {
		middle = MathHelper.GetMiddleDiff(p1.Pointd, p2.Pointd); //TODO: this need to be the middle of the screen.
		double distance = MathHelper.LengthTo(middle, p1.Pointd);

		scale = max(min(distance/10, 1.1), 1); //Hope this works :3

		Log.MainLogger.Info!Update("middle: %fx%f\t\tscale: %f", middle.x, middle.y, scale);


	}

	@property SDL_Pointd Middle() { return middle; }
	@property double Scale() { return scale; }
private:
	Engine* engine;
	SDL_Pointd middle; //aka xShift, yShift
	double scale = 0;
}

