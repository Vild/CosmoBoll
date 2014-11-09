module space.graphics.ball;

import space.graphics.texture;
import space.physics.aabb;
import space.engine;

class Ball {
public:
	this(Engine* engine, Texture tex, AABB pos) {
		this.engine = engine;
		this.tex = tex;
		this.pos = pos;
		this.isHooked = false;
	}

	void Update(double delta, double speed, double gravity, AABB[] colideWith) {
		if (isHooked)
			return;
		double dvx = 0;
		double dvy = 0;
		
		dvy += gravity;

		pos.Update(delta, dvx, dvy, colideWith);
	}
	
	void Render() {
		tex.Render(null, &pos.Rect(), false);
	}

	@property ref AABB Pos() { return pos; }
	@property ref bool IsHooked() { return isHooked; }
private:
	Engine* engine;
	Texture tex;
	AABB pos;
	bool isHooked;
}
