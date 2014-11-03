module app;
import std.stdio;
import space.log.log;
import space.engine;
import space.states.introstate;


int main(string[] args){
	Log log = Log.MainLogger;
	log.LogFile = File("space.log", "a");

	Engine engine = new Engine("Cosmo Boll", 1366, 768, true);
	engine.State = new IntroState(&engine);
	engine.MainLoop();

	log.LogFile.close();
	return 0;
}