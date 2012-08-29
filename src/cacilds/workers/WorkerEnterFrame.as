package cacilds.workers
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.MessageChannel;
	import flash.system.Worker;

	/**
	 * @author @silviopaganini | s2paganini.com
	 * unit9 2012 
	 * All rights reserved.
	 */
	public class WorkerEnterFrame extends Sprite
	{
		public var counter : int = 0;
		private var commandChannel : MessageChannel;
		private var output : MessageChannel;
		
		public function WorkerEnterFrame()
		{
			output = Worker.current.getSharedProperty("channel") as MessageChannel;
			
			commandChannel = Worker.current.getSharedProperty("incomingCommandChannel") as MessageChannel;
            commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
		}

		private function handleCommandMessage(event : Event) : void
		{
			var message : String = String(commandChannel.receive());
			switch(message)
			{
				case "startEnterFrame":
					addEventListener(Event.ENTER_FRAME, ef);	
					break;
			}
		}

		private function ef(event : Event) : void
		{
			counter++;
			output.send(counter);
		}
	}
}
