package com.netoleal.facebook.members
{
	public class FacebookUserFactory
	{
		private static var users:Object;
		
		public static function getUser( uid:String, p_raw:Object = null ):FacebookUser
		{
			if( !users ) users = new Object( );
			if( !users[ uid ] ) users[ uid ] = new FacebookUser( uid, p_raw );
			
			return users[ uid ];
		}
		
		public static function removeUser( user:FacebookUser ):void
		{
			if( user && users && users[ user.id ] ) users[ user.id ] = null;
		}
	}
}