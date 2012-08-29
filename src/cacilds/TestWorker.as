package cacilds
{
	import cacilds.workers.WorkerEnterFrame;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;

	public class TestWorker extends Sprite
	{
		private var worker : Worker;
		private var mainWorker : Worker;
		private var workerToMain : MessageChannel;
		private var bgWorkerCommandChannel : MessageChannel;
		
		public function TestWorker()
		{
			super();
			
			// create main worker
			mainWorker = WorkerDomain.current.createWorker(loaderInfo.bytes);
			
			// create background worker
			worker = WorkerFactory.getWorkerFromClass(WorkerEnterFrame, loaderInfo.bytes);
			
			// create background worker channel -> worker to main communication 
			workerToMain = worker.createMessageChannel(Worker.current);
			
			// create background worker channel -> main to worker communication
			bgWorkerCommandChannel = Worker.current.createMessageChannel(worker);
			
			// set shared workers channels
			worker.setSharedProperty("incomingCommandChannel", bgWorkerCommandChannel);
			worker.setSharedProperty('channel', workerToMain);
			
			// listen for the message from the worker
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE, workerHandler);
			
			// listen for the work to start
			worker.addEventListener(Event.WORKER_STATE, workerStateHandler);
			
			// start the worker
			worker.start();
		}

		/**
		 * Worker Status Handler
		 */
		private function workerStateHandler(event : Event) : void
		{
			if(worker.state == "running")
			{
				// tell worker to start enter frame listener
				bgWorkerCommandChannel.send("startEnterFrame");
			}
		}

		/**
		 * Worker Channel Handler
		 */
		private function workerHandler(event : Event) : void
		{
			trace("main", workerToMain.receive());
		}
	}
}
