package com.netoleal.facebook.connections
{
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.events.EventDispatcher;

	public class BaseConnection extends EventDispatcher
	{
		protected var _user:FacebookUser;
		
		public function BaseConnection( p_user:FacebookUser )
		{
			_user = p_user;
		}
		
		protected function concatObjects( ... args ):Object
		{
			var result:Object = { };
			var k:String;
			var o:Object;
			
			for each( o in args )
			{
				if( o ) for( k in o )
				{
					result[ k ] = o[ k ];
				}
			}
			
			return result;
		}
	}
}