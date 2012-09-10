AS3 Workers Manager
================

Manage and create AS3 Workers using as3swf lib

How
================

```actionscript
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

private function ready () : void
{
	workr.get("enterFrame").send("startEnterFrame");
}

private function workerHandler(event : Event) : void
{
	trace(workr.get("enterFrame").receive());
}
```