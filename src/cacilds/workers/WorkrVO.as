package cacilds.workers
{
	import flash.system.WorkerState;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	/**
	 * @author @silviopaganini | s2paganini.com
	 * unit9 2012 
	 * All rights reserved.
	 */
	public class WorkrVO extends Object
	{
		public var workr : Worker;
		public var channelMainToWorker : MessageChannel;
		public var channelWorkerToMain : MessageChannel;
		public var ready : Function = null;
		
		public function WorkrVO(workr : Worker, mainToWorker : MessageChannel, workerToMain : MessageChannel)
		{
			this.workr = workr;
			this.workr.addEventListener(Event.WORKER_STATE, workerStateHandler);
			this.channelMainToWorker = mainToWorker;
			this.channelWorkerToMain = workerToMain;
		}

		private function workerStateHandler(event : Event) : void
		{
			switch(workr.state)
			{
				case WorkerState.NEW:
					break;
					
				case WorkerState.RUNNING:
					if (typeof(ready) == "function") ready();
					break;
					
				case WorkerState.TERMINATED:
					break;
			}
		}
		
		public function send(arg : *) : void
		{
			channelMainToWorker.send(arg);
		}
		
		public function receive() : *
		{
			return channelWorkerToMain.receive();	
		}
		
		public function addEventListener(type : String, listener : Function) : void
		{
			workr.addEventListener(type, listener, false, 0, true);
		}
		
		public function removeEventListener(type : String, listener : Function) : void
		{
			workr.removeEventListener(type, listener);
		}
		
		public function listen(listener : Function) : void
		{
			channelWorkerToMain.addEventListener(Event.CHANNEL_MESSAGE, listener);
		}
	}
}
