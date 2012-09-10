package cacilds.workers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;

	/**
	 * @author @silviopaganini | s2paganini.com
	 * unit9 2012 
	 * All rights reserved.
	 */
	public class AbstractWorker extends Sprite
	{
		protected var output : MessageChannel;
		protected var input : MessageChannel;
		
		private var counter : Number = 0;
		
		public function AbstractWorker()
		{
			super();
			output = Worker.current.getSharedProperty("workerToMain") as MessageChannel;
			
			input = Worker.current.getSharedProperty("mainToWorker") as MessageChannel;
            input.addEventListener(Event.CHANNEL_MESSAGE, channelHandler);
		}

		private function channelHandler(event : Event) : void
		{
			handleCommandMessage(String(input.receive()));
		}

		protected function handleCommandMessage(command : String) : void
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
		
		protected function send(arg : *) : void
		{
			output.send(arg);
		}
	}
}
