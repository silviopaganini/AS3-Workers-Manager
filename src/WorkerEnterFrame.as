package 
{
	import cacilds.workers.AbstractWorker;

	import flash.events.Event;

	/**
	 * @author @silviopaganini | s2paganini.com
	 * unit9 2012 
	 * All rights reserved.
	 */
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

		private function ef(event : Event) : void
		{
			counter++;
			send(counter);
		}
	}
}
