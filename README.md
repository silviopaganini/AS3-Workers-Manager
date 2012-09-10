AS3 Workers Manager
================

Manage and create AS3 Workers using as3swf lib

How
================

Main.as

```actionscript
function init() : void
{
	// Set the Workers Manager the swf bytes 
	Workr.bytesMain = loaderInfo.bytes;

	// initiate the singleton
	workr = Workr.getInstance();

	// create as many workers you want
	workr.create(WorkerEnterFrame, "enterFrame");

	// listen for the events
	workr.get("enterFrame").listen(workerHandler);

	// listen for the worker start 
	workr.get("enterFrame").ready = ready;

	// start the workers
	workr.start();
}

private function ready () : void
{
	workr.get("enterFrame").send("startEnterFrame");
}

private function workerHandler(event : Event) : void
{
	trace(workr.get("enterFrame").receive());
}
```

WorkerEnterFrame.as
```actionscript
public class WorkerEnterFrame extends AbstractWorker
{
	private var counter : Number = 0;

	public function WorkerEnterFrame()
	{
		super();
	}

	override protected function handleCommandMessage(command : String) : void
	{
		switch(command)
		{
			case "startEnterFrame":
				addEventListener(Event.ENTER_FRAME, ef);
				break;
		}
	}

	// execute your commands and send the info back to the main application
	private function ef(event : Event) : void
	{
		counter++;
		send(counter);
	}
}
```