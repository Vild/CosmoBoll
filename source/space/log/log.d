module space.log.log;

version(Posix)
	import space.log.terminal : stdout, stderr, Color;
else
	import std.stdio : stdout, stderr;
import std.traits : isSomeChar, isAggregateType, isSomeString, isIntegral, isBoolean, fullyQualifiedName;
import std.conv : toTextRange;
import std.string : format;

enum LogLevel {
	VERBOSE,
	DEBUG,
	INFO,
	WARNING,
	SEVERE
};

class Log {
public:
	static Log MainLogger() { 
		if (mainLogger is null) {
			mainLogger = new Log();
			mainLogger.AttachHandler(&TerminalHandler);
			version(Posix) {
				stdout.restoreDefaults;
				stderr.restoreDefaults;
			}
		}
		return mainLogger;
	}
	
	alias LogHandlerFunc = void function(LogLevel level, string module_, lazy string message);

	void AttachHandler(LogHandlerFunc handler) {
		handlers ~= handler;
	}

	void opCall(S...)(LogLevel level, string module_, lazy string format_, lazy S args) {
		foreach(LogHandlerFunc handler ; handlers)
			handler(level, module_, formatMessage(format_, args));
	}

	template Verbose(alias this_) {
		void Verbose(S...)(lazy string format, lazy S args) {
			Log(LogLevel.VERBOSE, fullyQualifiedName!(this_), format, args);
		}
	}

	template Debug(alias this_) {
		void Debug(S...)(lazy string format, lazy S args) {
			Log(LogLevel.DEBUG, fullyQualifiedName!(this_), format, args);
		}
	}

	template Info(alias this_) {
		void Info(S...)(lazy string format, lazy S args) {
			Log(LogLevel.INFO, fullyQualifiedName!(this_), format, args);
		}
	}

	template Warning(alias this_) {
		void Warning(S...)(lazy string format, lazy S args) {
			Log(LogLevel.WARNING, fullyQualifiedName!(this_), format, args);
		}
	}

	template Severe(alias this_) {
		void Severe(S...)(lazy string format, lazy S args) {
			Log(LogLevel.SEVERE, fullyQualifiedName!(this_), format, args);
		}
	}

	template Critical(alias this_) {
		void Critical(S...)(lazy string format, lazy S args) {
			import std.c.stdlib : exit;
			Log(LogLevel.SEVERE, fullyQualifiedName!(this_), format, args);
			exit(-1);
		}
	}

private:
	static Log mainLogger = null;
	LogHandlerFunc[] handlers;

	string formatMessage(S...)(lazy string format_, lazy S args) {
		string message = format_;
		static if (args.length > 0)
			message = format(format_, args);
		return message;
	}

	version(Posix) {
		static void TerminalHandler(LogLevel level, string module_, lazy string message) {
			char icon = ' ';

			Color fg = Color.white;
			Color bg = Color.black;
			bool bold = false;

			switch (level) {
				case LogLevel.VERBOSE:
					icon = '&';
					fg = Color.cyan;
					bg = Color.black;
					bold = false;
					break;
				case LogLevel.DEBUG:
					icon = '%';
					fg = Color.green;
					bg = Color.black;
					bold = false;
					break;
				case LogLevel.INFO:
					icon = '*';
					fg = Color.white;
					bg = Color.black;
					bold = false;
					break;
				case LogLevel.WARNING:
					icon = '#';
					fg = Color.white;
					bg = Color.yellow;
					bold = true;
					break;
				case LogLevel.SEVERE:
					icon = '!';
					fg = Color.white;
					bg = Color.red;
					bold = true;
					break;
				default:
					icon = '?';
					break;
			}

			string levelText = format("[%c] [%s]\t %s", icon, module_, message);
			
			stdout.bold = bold;
			stdout.foregroundColor = fg;
			stdout.backgroundColor = bg;
			stdout.write(levelText);
			stdout.flush;
			stdout.restoreDefaults;
			stdout.writeln;
		}
	} else {
		static void TerminalHandler(LogLevel level, string module_, lazy string message) {
			return StdTerminalHandler(level, module_, message);
		}
	}

	static void StdTerminalHandler(LogLevel level, string module_, lazy string message) {
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
		
		string levelText = format("[%c] [%s]\t %s", icon, module_, message);
		
		if (level >= LogLevel.WARNING) {
			stderr.writeln(levelText);
			stderr.flush;
		} else {
			stdout.writeln(levelText);
			stdout.flush;
		}
	}
}

