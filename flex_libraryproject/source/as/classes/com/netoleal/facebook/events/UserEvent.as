/**
 * @author: Neto Leal
 *
 **/
package com.netoleal.facebook.events
{
	import com.netoleal.facebook.members.FacebookUser;
	
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		public static const FRIENDS_LOADED:String = "friendsLoaded";
		public static const ALL_FRIENDS_DATA_LOADED:String = "allFriendsDataLoaded";
		public static const FRIEND_DATA_LOADED:String = "friendDataLoaded";
		
		public var friend:FacebookUser;
		
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}