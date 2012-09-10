package cacilds.workers
{
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * @author @silviopaganini | s2paganini.com
	 * unit9 2012 
	 * All rights reserved.
	 * 
	 * Worker Manager
	 */
	 
	public class Workr
	{
		private static var instance : Workr;
		public static var bytesMain : ByteArray;
		 
		private var mainWorker : Worker;
		private var workers : Dictionary;
		
		public static function getInstance() : Workr
		{
			if(!instance) instance = new Workr();
			return instance;
		}
		
		public function Workr()
		{
			workers = new Dictionary();
			mainWorker = WorkerDomain.current.createWorker(bytesMain);
		}
		
		public function create(workerClass : Class, id : String) : void
		{
			var worker : Worker = WorkerFactory.getWorkerFromClass(workerClass, bytesMain, true, WorkerDomain.current);
			var workerToMain : MessageChannel = worker.createMessageChannel(Worker.current);
			var mainToWorker : MessageChannel = Worker.current.createMessageChannel(worker);
			
			worker.setSharedProperty("workerToMain", workerToMain);
			worker.setSharedProperty("mainToWorker", mainToWorker);
			
			workers[id] = new WorkrVO(worker, mainToWorker, workerToMain);
		}
		
		public function start() : void
		{
			for(var n : String in workers)
			{
				WorkrVO(workers[n]).workr.start();
			}
		}
		
		public function get (id : String) : WorkrVO
		{
			return workers[id];
		}
	}
}
