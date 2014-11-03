module space.enginestate;
import space.engine;

abstract class EngineState {
public:
	this(Engine* engine) {
		this.engine = engine;
	}

	abstract void Update(double delta);
	abstract void Render();

protected:
	Engine* engine;
}

