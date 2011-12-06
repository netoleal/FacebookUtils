package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	import com.netoleal.facebook.members.FacebookUser;
	import com.netoleal.facebook.members.FacebookUserFactory;
	
	import flash.net.URLRequestMethod;
	
	public class AlbumPhotoModel extends BaseModel
	{
		private var tagSeq:Sequence;
		
		public function AlbumPhotoModel(p_raw:*)
		{
			super(p_raw);
			
			tagSeq = new Sequence( );
		}
		
		public function createTag( toUserID:String, x:uint = 0, y:uint = 0 ):ISequence
		{
			tagSeq.notifyStart( );
			
			Facebook.api( id + "/tags", onCreateTag, { to: toUserID, x: x, y: y }, URLRequestMethod.POST );
			
			return tagSeq;
		}
		
		private function onCreateTag( result:Object, error:Object ):void
		{
			tagSeq.notifyComplete( result != null, result );
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