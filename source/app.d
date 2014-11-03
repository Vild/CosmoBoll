module app;
import std.stdio;
import space.log.log;
import space.engine;

File f;
Log log;

int main(string[] args){
	log = Log.MainLogger;
	f = File("space.log", "a");
	log.AttachHandler(&fileLog);


	Engine engine = new Engine();
	engine.MainLoop();


	f.close();
	return 0;
}

static void fileLog(LogLevel level, string module_, lazy string message) {
	import std.string;
	import std.datetime;
	char icon = ' ';
	
	switch (level) {
		case LogLevel.VERBOSE:
			icon = '&';
			break;
		case LogLevel.DEBUG:
			icon = '%';
			break;
		case LogLevel.INFO:
			icon = '*';
			break;
		case LogLevel.WARNING:
			icon = '#';
			break;
		case LogLevel.SEVERE:
			icon = '!';
			break;
		default:
			icon = '?';
			break;
	}

	SysTime t = Clock.currTime;

	auto dateTime = DateTime(Date(t.year, t.month, t.day), TimeOfDay(t.hour, t.minute, t.second));

	string time = dateTime.toSimpleString;

	string levelText = format("[%c] [%s] [%s]\t %s", icon, module_, time, message);

	f.writeln(levelText);
	f.flush();
}