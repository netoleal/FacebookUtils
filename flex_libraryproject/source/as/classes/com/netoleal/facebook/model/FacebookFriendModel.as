/**
 * @author: Neto Leal
 *
 **/
package com.netoleal.facebook.model
{
	public class FacebookFriendModel
	{
		private var raw:Object;
		
		public function FacebookFriendModel( p_raw:Object )
		{
			raw = p_raw;
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function get name( ):String
		{
			return raw.name;
		}
		
		public function get user( ):FacebookUserModel
		{
			return FacebookUserFactory.getUser( this.id );
		}
		
		public function dispose( ):void
		{
			raw = null;
			if( user )
			{
				user.dispose( );
			}
		}
	}
}