module app;
import space.engine;
import space.log.log;
import space.states.mainmenustate;
import std.math;
import std.stdio;

int main(string[] args){
	FloatingPointControl fpctrl;
	fpctrl.enableExceptions(FloatingPointControl.severeExceptions);

	Log log = Log.MainLogger;
	log.LogFile = File("space.log", "a");

	Engine engine = new Engine("Cosmo Boll", 1366, 768, false);
	engine.ChangeState!MainMenuState(&engine);
	engine.MainLoop();

	log.LogFile.close();
	return 0;
}