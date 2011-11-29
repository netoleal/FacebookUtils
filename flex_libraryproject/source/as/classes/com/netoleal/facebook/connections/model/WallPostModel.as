package com.netoleal.facebook.connections.model
{
	import asf.core.models.app.BaseModel;
	import asf.core.util.Sequence;
	import asf.interfaces.ISequence;
	
	import com.facebook.graph.Facebook;
	
	public class WallPostModel extends BasePostEntityModel
	{
		private var _comments:Vector.<WallPostCommentModel>;
		private var data:Object;
		private var loadSeq:Sequence;
		
		public function WallPostModel( p_raw:* )
		{
			super( p_raw );
			
			loadSeq = new Sequence( );
		}
		
		public function load( forceRefresh:Boolean = false ):ISequence
		{
			loadSeq.notifyStart( );
			
			if( !forceRefresh && isLoaded )
			{
				return loadSeq.notifyComplete( this );
			}
			
			Facebook.api( "/" + this.id, onLoadDataComplete );
			
			return loadSeq;
		}
		
		private function onLoadDataComplete( result:Object, error:Object ):void
		{
			data = result;
			loadSeq.notifyComplete( this );
		}
		
		public function picture( ):String
		{
			return data.picture;
		}
		
		public function get link( ):String
		{
			return data.link;
		}
		
		public function get description( ):String
		{
			return data.description;
		}
		
		public function get icon( ):String
		{
			return data.icon;
		}
		
		public function get isLoaded( ):Boolean
		{
			return data != null;
		}
		
		public function get actions( ):Array
		{
			return raw.actions;
		}
		
		public function get application( ):WallPostApplicationModel
		{
			return new WallPostApplicationModel( raw.application );
		}
		
		public function get comments( ):Vector.<WallPostCommentModel>
		{
			if( !_comments )
			{
				var rawObject:Object;
				
				_comments = new Vector.<WallPostCommentModel>( );
				
				for each( rawObject in raw.comments.data )
				{
					_comments.push( new WallPostCommentModel( rawObject ) );
				}
			}
			
			return _comments;
		}
		
		public function get likesCount( ):uint
		{
			return raw.likes.count;
		}
		
		public function get likes( ):Array
		{
			return raw.likes.data;
		}
		
		public function get type( ):String
		{
			return raw.type;
		}
		
		public function get updatedTime( ):Date
		{
			return raw.updated_time;
		}
	}
}