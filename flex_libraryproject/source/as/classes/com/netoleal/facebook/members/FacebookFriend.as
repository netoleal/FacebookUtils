/**
 * @author: Neto Leal
 *
 **/
package com.netoleal.facebook.members
{
	public class FacebookFriend
	{
		private var raw:Object;
		
		public function FacebookFriend( p_raw:Object )
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
		
		public function get user( ):FacebookUser
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