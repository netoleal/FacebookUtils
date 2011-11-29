package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	
	public class BasePostEntityModel extends BaseModel
	{
		public function BasePostEntityModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get message( ):String
		{
			return raw.message;
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function get createdTime( ):Date
		{
			return raw.created_time;
		}
		
		public function get fromUser( ):FacebookUser
		{
			return FacebookUserFactory.getUser( raw.from.id );
		}
		
		public function get fromUserName( ):String
		{
			return raw.from.name;
		}
	}
}