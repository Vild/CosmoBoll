module app;
import std.stdio;
import space.log.log;
import space.engine;
import space.states.mainmenustate;

int main(string[] args){
	Log log = Log.MainLogger;
	log.LogFile = File("space.log", "a");

	Engine engine = new Engine("Codename Space - Lorem Ipsum", 1366, 768, false);
	engine.State = new MainMenuState(&engine);
	engine.MainLoop();

	log.LogFile.close();
	return 0;
}