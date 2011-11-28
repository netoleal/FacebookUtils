package com.netoleal.facebook.model
{
	public class FacebookUserFactory
	{
		private static var users:Object;
		
		public static function getUser( uid:String, p_raw:Object = null ):FacebookUserModel
		{
			if( !users ) users = new Object( );
			if( !users[ uid ] ) users[ uid ] = new FacebookUserModel( uid, p_raw );
			
			return users[ uid ];
		}
		
		public static function removeUser( user:FacebookUserModel ):void
		{
			if( user && users && users[ user.id ] ) users[ user.id ] = null;
		}
	}
}