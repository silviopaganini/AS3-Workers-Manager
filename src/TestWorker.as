package 
{
	import cacilds.workers.Workr;

	import flash.display.Sprite;
	import flash.events.Event;


	public class TestWorker extends Sprite
	{
		private var workr : Workr;
				
		public function TestWorker()
		{
			super();
			
			Workr.bytesMain = loaderInfo.bytes;
			workr = Workr.getInstance();
			workr.create(WorkerEnterFrame, "enterFrame");
			
			workr.get("enterFrame").listen(workerHandler);
			workr.get("enterFrame").ready = ready;
			
			// start the workers
			workr.start();
		}
		
		private function ready () : void
		{
			workr.get("enterFrame").send("startEnterFrame");
		}

		/**
		 * Worker Channel Handler
		 */
		private function workerHandler(event : Event) : void
		{
			trace(workr.get("enterFrame").receive());
		}
	}
}
