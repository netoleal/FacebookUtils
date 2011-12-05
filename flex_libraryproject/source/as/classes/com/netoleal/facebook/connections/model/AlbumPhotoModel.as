package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	
	public class AlbumPhotoModel extends BaseModel
	{
		public function AlbumPhotoModel(p_raw:*)
		{
			super(p_raw);
		}
		
		public function get id( ):String
		{
			return raw.id;
		}
		
		public function get link( ):String
		{
			return raw.link;
		}
		
		public function get pictureURL( ):String
		{
			return raw.picture;
		}
		
		public function get source( ):String
		{
			return raw.source;
		}
		
		public function get updatedTime( ):Date
		{
			return raw.updated_time;
		}
		
		public function get smallPicture( ):String
		{
			var c:Array = ( raw.images as Array ).slice( );
			
			c.sortOn( "width" );
			
			if( c.length > 0 )
			{
				return c[ 0 ].source;
			}
			
			return "";
		}
		
		public function get largePicture( ):String
		{
			var c:Array = ( raw.images as Array ).slice( );
			
			c.sortOn( "width" );
			
			if( c.length > 0 )
			{
				return c.pop( ).source;
			}
			
			return "";
		}
		
		public function get mediumPicture( ):String
		{
			var c:Array = ( raw.images as Array ).slice( );
			
			c.sortOn( "width" );
			
			if( c.length > 0 )
			{
				c.pop( );
				c.shift( );
				
				if( c.length > 0 )
				{
					return c.pop( ).source;
				}
			}
			
			return "";
		}
		
		public function get images( ):Array
		{
			return raw.images;
		}
		
		public function get createdTime( ):Date
		{
			return raw.created_time;
		}
		
		public function get fromUser( ):FacebookUser
		{
			return FacebookUserFactory.getUser( raw.from.id );
		}
		
		public function get fromName( ):String
		{
			return raw.from.name;
		}
		
		public function get height( ):Number
		{
			return raw.height;
		}
		
		public function get width( ):Number
		{
			return raw.width;
		}
	}
}