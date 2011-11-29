package com.netoleal.facebook.events
{
	import flash.events.Event;
	
	public class FacebookApplicationEvent extends Event
	{
		public static const USER_LOAD_START:String = "userLoadStart";
		public static const USER_LOAD_COMPLETE:String = "userLoadComplete";
		
		public static const LOGIN_START:String = "loginStart";
		public static const LOGIN_COMPLETE:String = "loginComplete";
		public static const LOGIN_FAIL:String = "loginFail";
		
		public function FacebookApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}